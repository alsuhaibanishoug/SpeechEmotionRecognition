import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saghi/models/ResponseModel.dart';
import 'package:saghi/models/emotion_model.dart';
import 'package:saghi/models/language_model.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../shared/helper/mangers/assets_manger.dart';
import '../../../../shared/helper/mangers/colors.dart';

part 'speech_state.dart';

class SpeechCubit extends Cubit<SpeechState> {
  SpeechCubit() : super(SpeechInitial());

  static SpeechCubit get(context) => BlocProvider.of(context);

  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  void init() async {
    speechEnabled = await speechToText.initialize();
    emit(State1());
  }

  void startListening() async {
    await speechToText.listen(
      onResult: onSpeechResult,
    );
    emit(State2());
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

  Future<void> stopListening() async {
    await speechToText.stop();
    emit(State3());
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    emit(State4());
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

      double angry = double.parse("${responseModel!.angry}".substring(0, 6));
      double sad = double.parse("${responseModel!.sad}".substring(0, 6));
      double surprise =
          double.parse("${responseModel!.surprise}".substring(0, 6));
      double happy = double.parse("${responseModel!.happy}".substring(0, 6));
      double neutral =
          double.parse("${responseModel!.neutral}".substring(0, 6));

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
      emit(GetUserEmoji());
    });
  }

  LanguageModel? choosdLangModel;

  void chooseLangModel(LanguageModel languageModel) {
    choosdLangModel = languageModel;
    emit(ChooseLangModel());
  }

  void convertTextToVoise({required String words}) async {
    await stopListening();
    final FlutterTts _flutterTts = FlutterTts();

    await _flutterTts.setLanguage(lang!);

    await _flutterTts.setSpeechRate(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    if (Platform.isIOS) _flutterTts.setSharedInstance(true);
    var uuid = Uuid();
    String name = uuid.v1().split("-")[0];
    String fileName = Platform.isAndroid ? '$name.wav' : '$name.caf';

    await _flutterTts.synthesizeToFile(words, fileName);
    final externalDirectory = await getExternalStorageDirectory();
    var path = '${externalDirectory!.path}/$fileName';
    uploadAudioFile(audioPath: path, audioLang: "ar");
  }
}
