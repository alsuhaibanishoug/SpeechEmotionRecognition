import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saghi/models/ResponseModel.dart';
import 'package:saghi/models/audio_model.dart';
import 'package:saghi/models/emotion_model.dart';
import 'package:saghi/models/language_model.dart';
import '../../../../shared/helper/mangers/assets_manger.dart';
import '../../../../shared/helper/mangers/colors.dart';
import 'package:flutter_audio_recorder3/flutter_audio_recorder3.dart';
import 'dart:io' as io;

part 'speech_state.dart';

class SpeechCubit extends Cubit<SpeechState> {
  SpeechCubit() : super(SpeechInitial());

  static SpeechCubit get(context) => BlocProvider.of(context);

  bool isPlaying = false;

  FlutterAudioRecorder3? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder3.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder =
            FlutterAudioRecorder3(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        var current = await _recorder!.current(channel: 0);
        _current = current;
        _currentStatus = current!.status!;
        emit(ChangePlayingState());
      } else {}
    } catch (e) {
      print(e);
    }
  }

  start() async {
    try {
      await _recorder!.start();
      isPlaying = true;
      var recording = await _recorder!.current(channel: 0);
      _current = recording;
      emit(State1());
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        _current = current;
        _currentStatus = _current!.status!;
        emit(State2());
      });
    } catch (e) {
      print(e);
    }
  }

  stop() async {
    var result = await _recorder!.stop();
    isPlaying = false;
    uploadAudioFile(
        audioPath: "${result!.path}",
        audioLang: "${choosdLangModel!.languageCode}.wav");
  }

  String? lang;

  void changeLanguage({required String langCode}) {
    if (langCode == "en") {
      lang = "en-US";
    } else {
      lang = "ar-SA";
    }
    emit(ChangeLangState());
  }

  File? audioFile;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mp3", "m4a", "wav", "avi"],
    );
    if (result != null) {
      audioFile = File(result.files.single.path!);
      emit(ChooseAudioSuccess());
    }
  }

  List<EmotionModel> listEmotionModel = [];
  List<double> _emotionListDouble = [];
  EmotionModel? emotionModel;
  ResponseModel? responseModel;

  void uploadAudioFile({required String audioPath, required audioLang}) async {
    print(audioLang);
    emit(UploadAudioLoading());
    Dio dio = Dio();
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        audioPath,
        filename: audioLang,
      ),
    });
    dio
        .post("http://shougsu.pythonanywhere.com/", data: formData)
        .then((value) {
      listEmotionModel.clear();
      _emotionListDouble.clear();
      responseModel = ResponseModel.fromJson(value.data);
      responseModel!.lang = audioLang;

      double angry = double.parse("${responseModel!.angry}".substring(0, 6));
      double sad = double.parse("${responseModel!.sad}".substring(0, 6));
      double surprise =
          double.parse("${responseModel!.surprise}".substring(0, 6));
      double happy = double.parse("${responseModel!.happy}".substring(0, 6));
      double neutral =
          double.parse("${responseModel!.neutral}".substring(0, 6));
      emit(GetUserEmoji());
      listEmotionModel.add(EmotionModel(
          value: angry,
          emojy: AssetsManger.angry,
          title: "Angry",
          color: ColorsManger.red));
      listEmotionModel.add(EmotionModel(
          value: sad,
          emojy: AssetsManger.sad,
          title: "sad",
          color: ColorsManger.orange));
      listEmotionModel.add(EmotionModel(
          value: surprise,
          emojy: AssetsManger.surprise,
          title: "Surprised",
          color: ColorsManger.orangeLight));
      listEmotionModel.add(EmotionModel(
          value: happy,
          emojy: AssetsManger.happy,
          title: "Happy",
          color: ColorsManger.blue));
      listEmotionModel.add(EmotionModel(
          value: neutral,
          emojy: AssetsManger.neutral,
          title: "Neutral",
          color: Colors.green));

      List<double> _customList = [];

      _customList.add(angry);
      _customList.add(sad);
      _customList.add(surprise);
      _customList.add(happy);
      _customList.add(neutral);

      double maxValue =
          _customList.reduce((curr, next) => curr > next ? curr : next);
      listEmotionModel.forEach((element) {
        if (element.value == maxValue) {
          emotionModel = element;
        }
      });
      //emit(GetUserEmoji());
      emit(ChooseLangModel());
    }).catchError((error) {
      print(error.response.data);
      print(error.response.statusCode);
    });
  }

  LanguageModel? choosdLangModel;

  void chooseLangModel(LanguageModel languageModel) {
    choosdLangModel = languageModel;
    emit(ChooseLangModel());
  }

  EmotionModel? emotionResultModel;
  AudioModel? audioModel2;

  void getFavItemData({required String docId}) {
    emit(GetFavItemsLoading());
    FirebaseFirestore.instance
        .collection("favouriteAudio")
        .doc(docId)
        .get()
        .then((value) {
      audioModel2 = AudioModel.fromJson(map: value.data() ?? {});

      listEmotionModel.clear();
      _emotionListDouble.clear();

      double angry = double.parse(audioModel2!.angry ?? "");
      double sad = double.parse("${audioModel2!.sad}");
      double surprise = double.parse("${audioModel2!.surprise}");
      double happy = double.parse("${audioModel2!.happy}");
      double neutral = double.parse("${audioModel2!.neutral}");
      String text = audioModel2!.text ?? '';

      listEmotionModel.add(EmotionModel(
          value: angry,
          emojy: AssetsManger.angry,
          title: "Angry",
          color: ColorsManger.red));
      listEmotionModel.add(EmotionModel(
          value: sad,
          emojy: AssetsManger.sad,
          title: "sad",
          color: ColorsManger.orange));
      listEmotionModel.add(EmotionModel(
          value: surprise,
          emojy: AssetsManger.surprise,
          title: "Surprised",
          color: ColorsManger.orangeLight));
      listEmotionModel.add(EmotionModel(
          value: happy,
          emojy: AssetsManger.happy,
          title: "Happy",
          color: ColorsManger.blue));
      listEmotionModel.add(EmotionModel(
          value: neutral,
          emojy: AssetsManger.neutral,
          title: "Neutral",
          color: Colors.green));

      List<double> customList = [];

      customList.add(angry);
      customList.add(sad);
      customList.add(surprise);
      customList.add(happy);
      customList.add(neutral);

      double maxValue =
          customList.reduce((curr, next) => curr > next ? curr : next);

      for (var element in listEmotionModel) {
        if (element.value == maxValue) {
          emotionResultModel = element;
        }
      }
      emit(GetFavItemsSuccess());
    });
  }
}
