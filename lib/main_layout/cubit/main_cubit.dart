import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart' as aui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saghi/models/audio_model.dart';
import 'package:saghi/models/user_model.dart';
import 'package:saghi/screens/layout/profile/profile.dart';
import 'package:saghi/screens/layout/speech_to_text/speech_to_text.dart';
import 'package:saghi/screens/layout/text_to_speech/text_to_speech.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'dart:io' show Platform;

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.speacker,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      icon: Image.asset(
        AssetsManger.speacker,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.listen,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      icon: Image.asset(
        AssetsManger.listen,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.profile,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      icon: Image.asset(
        AssetsManger.profile,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      label: "",
    ),
  ];

  int currentIndex = 1;

  void changeCurrentIndex({required int index}) {
    currentIndex = index;
    if (index == 2) {
      getUserInfo();
    }
    emit(ChangeIndexState());
  }

  List<Widget> screens = [
    TextToSpeechScreen(),
    SpeechToTextScreen(isFromMain: true),
    ProfileScreen(true),
  ];

  File? userImage;

  void pickUserImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      userImage = File(image.path);
      storage.FirebaseStorage.instance
          .ref(ConstantsManger.users)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .putFile(userImage!)
          .then((task) async {
        String downloadUrl = await task.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection(ConstantsManger.users)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"image": downloadUrl});
      });
      emit(PickeUserImageState());
    }
  }

  UserModel? userModel;

  void getUserInfo() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      userModel = UserModel.fromJson(map: event.data() ?? {});
      emit(GetUserModelSuccess());
    });
  }

  /////////////////////////////// Screen 1 ///////////////////////////

  void init() {
    player.onPlayerStateChanged.listen((state) {
      isPlaying = state == aui.PlayerState.playing;
      emit(initStatePlayingState());
    });
    player.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      emit(ChangeDurationState());
    });
    player.onPositionChanged.listen((newPosition) {
      position = newPosition;
      emit(ChangePostionDurationState());
    });
  }

  void changeSlider(double value) async {
    final pos = Duration(seconds: value.toInt());
    player.seek(pos);
    await player.resume();
    emit(ChangeSliderValueState());
  }

  String formatTime(int second) {
    return '${(Duration(seconds: second))}'.split(".")[0].padLeft(8, "0");
  }

  final FlutterTts _flutterTts = FlutterTts();
  String? soundUrl;

  late var fileName;
  String? lang;

  void changeLanguage({required String langCode}) {
    if (langCode == "en") {
      lang = "en-US";
    } else {
      lang = "ar-SA";
    }
    emit(ChangeLangState());
  }

  Future createAudioScript({required String script}) async {
    await _flutterTts.setLanguage(lang!);

    await _flutterTts.setSpeechRate(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    if (Platform.isIOS) _flutterTts.setSharedInstance(true);

    fileName = Platform.isAndroid ? 'name.wav' : 'name.caf';

    await _flutterTts.synthesizeToFile(script, fileName);
    final externalDirectory = await getExternalStorageDirectory();
    var path = '${externalDirectory!.path}/$fileName';
    final firebaseStorage = FirebaseStorage.instance;
    var snapshot =
        await firebaseStorage.ref().child(ConstantsManger.allAudios).putFile(
            File(path),
            SettableMetadata(
              contentType: 'audio/mp3',
            ));
    soundUrl = await snapshot.ref.getDownloadURL();
    emit(AddAudioState());
  }

  final player = AudioPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  void playSoundOrStopPlaying({required String soundLink}) {
    if (isPlaying) {
      player.pause();
    } else {
      player.setPlaybackRate(0.4);
      player.play(UrlSource(soundLink));
    }
    isPlaying = !isPlaying;
    emit(PlaySoundState());
  }

///////////////////////////////// Profile ///////////////////

  void updateUserInfo({required String first, required String last}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "firstName": first,
      "lastName": last,
    }).then((value) {
      emit(UpdateProfileInfo());
    });
  }

  List<AudioModel> resultFavList = [];

  void getAllFavResult() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.FAV)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((value) {
      resultFavList.clear();
      for (var element in value.docs) {
        resultFavList.add(AudioModel.fromJson(map: element.data()));
      }
      emit(GetAllResultListState());
    });
  }

  void deleteResult({required String id}) async {
    await FirebaseFirestore.instance
        .collection(ConstantsManger.FAV)
        .doc(id)
        .delete();
  }
}
