import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saghi/models/emotion_model.dart';
import 'package:saghi/models/language_model.dart';
import 'package:saghi/screens/layout/speech_to_text/cubit/speech_cubit.dart';
import 'package:saghi/screens/layout/speech_to_text/widget/result_page.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/custom_button.dart';
import 'package:saghi/widget/custom_loading.dart';
import 'package:saghi/widget/emotion_deisgn.dart';
import 'package:saghi/widget/lang_drop_down.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../shared/helper/mangers/colors.dart';
import 'widget/guide_linde.dart';

class SpeechToTextScreen extends StatelessWidget {
  final bool isFromMain;
  PageController pageController = PageController(initialPage: 0);

  SpeechToTextScreen({super.key, required this.isFromMain});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpeechCubit, SpeechState>(
      listener: (context, state) {
        if (state is UploadAudioLoading) {
          showToast(
            msg: "Your audio is being processed",
            gravity: ToastGravity.CENTER,
          );
        }
        if (state is StopRecorderState) {
          pageController.animateToPage(3,
              duration: const Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn);
        }
        if (state is GetUserEmoji) {
          if (isFromMain) {
            navigateTo(
                context, ResultScreen(SpeechCubit.get(context), isFromMain));
          } else {
            pageController.animateToPage(5,
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn);
          }
        }
      },
      builder: (context, state) {
        SpeechCubit cubit = SpeechCubit.get(context);
        return PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            setUpBody(cubit, context, state),
            setUpBod2(cubit),
            setBody3(cubit),
            setUpBody4(cubit),
            setUpUpload(cubit, state),
            ResultScreen(cubit, false),
          ],
        );
      },
    );
  }

  PreferredSizeWidget? createAppBar(context, state) {
    if (state is GetUserEmoji && !isFromMain) {
      return null;
    } else {
      return AppBar(
        title: InkWell(
          onTap: () {
            pageController.animateToPage(4,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn);
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 10, start: 10),
            child: Container(
              alignment: AlignmentDirectional.topStart,
              child: Column(
                children: [
                  Icon(Icons.drive_folder_upload),
                  AppText(
                    text: "Upload",
                    color: ColorsManger.darkPrimary,
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => navigateTo(
                  context,
                  ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => const GuideLineSpeechToText(),
                  ))),
              icon: Icon(
                Icons.help_center,
                color: ColorsManger.darkPrimary,
              ))
        ],
      );
    }
  }

  Widget setUpBody(SpeechCubit cubit, context, state) {
    return Scaffold(
      appBar: createAppBar(context, state),
      body: Column(
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight * .45),
          AppText(
              text: cubit.isPlaying ? " Tap To Stop" : " Tap To Record",
              textSize: 20),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 80),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state is UploadAudioLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : Container(
                        child: AvatarGlow(
                          endRadius: 80,
                          animate: cubit.isPlaying,
                          glowColor: ColorsManger.orangePrimary,
                          child: FloatingActionButton.large(
                              backgroundColor: cubit.isPlaying
                                  ? ColorsManger.orangePrimary
                                  : ColorsManger.darkPrimary,
                              onPressed: () {
                                if (cubit.lang == null) {
                                  showToast(
                                    msg: "please choose language first",
                                    gravity: ToastGravity.CENTER,
                                    color: Colors.red,
                                  );
                                } else {
                                  cubit.isPlaying
                                      ? cubit.stop()
                                      : cubit.start();
                                }
                              },
                              child: cubit.isPlaying
                                  ? Icon(Icons.square_rounded, size: 40)
                                  : Icon(Icons.mic, size: 70)),
                        ),
                      ),
                SizedBox(width: SizeConfigManger.bodyHeight * .02),
                PopupMenuButton<LanguageModel>(
                    icon: Image.asset('assets/icons/lang.png'),
                    onSelected: (LanguageModel item) async {
                      cubit.changeLanguage(langCode: item.languageCode);
                      cubit.chooseLangModel(item);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<LanguageModel>>[
                          PopupMenuItem<LanguageModel>(
                            value: LanguageModel.choices[0],
                            child: Row(
                              children: [
                                SizedBox(
                                    width: SizeConfigManger.bodyHeight * .02),
                                AppText(text: "English")
                              ],
                            ),
                          ),
                          PopupMenuItem<LanguageModel>(
                            value: LanguageModel.choices[1],
                            child: Row(
                              children: [
                                SizedBox(
                                    width: SizeConfigManger.bodyHeight * .02),
                                AppText(text: "Arabic")
                              ],
                            ),
                          ),
                        ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setUpBod2(SpeechCubit cubit) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(height: SizeConfigManger.bodyHeight * .02),
        Container(
          height: SizeConfigManger.bodyHeight * .4,
          padding: const EdgeInsets.all(20),
          width: SizeConfigManger.screenWidth * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(20))),
          child: AppText(
            text: "cubit.lastWords",
            maxLines: 25,
          ),
        ),
        SizedBox(height: SizeConfigManger.bodyHeight * .02),
        Center(child: AppText(text: "Tap To Stop", textSize: 20)),
        SizedBox(height: SizeConfigManger.bodyHeight * .02),
        InkWell(
          onTap: () async {
            pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.bounceInOut);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManger.darkPrimary,
            ),
            child: const Icon(Icons.mic_off, size: 60, color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfigManger.bodyHeight * .04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AbsorbPointer(
                absorbing: true /*"cubit.speechToText.isListening"*/,
                child: InkWell(
                  onTap: () async {
                    pageController.previousPage(
                        duration: const Duration(microseconds: 200),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManger.darkPrimary,
                    ),
                    child: Image.asset("assets/images/retern.png"),
                  ),
                ),
              ),
              AbsorbPointer(
                absorbing: true /*cubit.speechToText.isListening*/,
                child: InkWell(
                  onTap: () async {},
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManger.darkPrimary,
                    ),
                    child:
                        const Icon(Icons.send, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget setBody3(SpeechCubit cubit) {
    if (cubit.emotionModel == null) {
      return const Center(
        child: CustomLoading(),
      );
    } else {
      return SafeArea(
          child: Column(
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfigManger.bodyHeight * .05),
            child: Align(
                alignment: AlignmentDirectional.topStart,
                child: AppText(
                    text: "Speaker is mostly:",
                    fontWeight: FontWeight.w500,
                    textSize: 22)),
          ),
          EmotionDesign(_getEmotionModel(emo: cubit.emotionModel!.title)),
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
        ],
      ));
    }
  }

  Widget setUpBody4(SpeechCubit cubit) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfigManger.bodyHeight * .05),
            child: Align(
                alignment: AlignmentDirectional.topStart,
                child: AppText(
                    text: "Speaker is mostly:",
                    fontWeight: FontWeight.w500,
                    textSize: 22)),
          ),
          EmotionDesign(emojiList[0]),
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfigManger.bodyHeight * .02),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius:
                    BorderRadius.circular(getProportionateScreenHeight(20))),
            child: Column(
              children: [
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  axes: [],
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                  ),
                  enableAxisAnimation: true,
                  series: <ChartSeries>[
                    ColumnSeries<EmotionModel, String>(
                      dataSource: [
                        emojiList[0],
                        emojiList[1],
                        emojiList[2],
                        emojiList[3],
                        emojiList[4],
                      ],
                      xValueMapper: (EmotionModel model, _) => model.title,
                      yValueMapper: (EmotionModel model, _) => model.value,
                      pointColorMapper: (data, _) => data.color,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: SizeConfigManger.screenWidth * .06),
                    EmotionDesign(emojiList[0]),
                    SizedBox(width: SizeConfigManger.screenWidth * .08),
                    EmotionDesign(emojiList[1]),
                    SizedBox(width: SizeConfigManger.screenWidth * .06),
                    EmotionDesign(emojiList[2]),
                    SizedBox(width: SizeConfigManger.screenWidth * .06),
                    EmotionDesign(emojiList[3]),
                    SizedBox(width: SizeConfigManger.screenWidth * .06),
                    EmotionDesign(emojiList[4]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setUpUpload(SpeechCubit cubit, state) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () => pageController.animateToPage(0,
                      duration: Duration(milliseconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn),
                  child: AppText(
                    text: 'Cancel',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    textSize: 24,
                  ),
                ),
                SizedBox(width: SizeConfigManger.screenWidth * .2),
                AppText(
                  text: 'Upload File',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textSize: 24,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfigManger.bodyHeight * .06),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfigManger.bodyHeight * .02),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfigManger.bodyHeight * .08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(15))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: SizeConfigManger.screenWidth * .25),
                    child: AppText(
                        text: cubit.audioFile == null
                            ? ""
                            : cubit.audioFile!.path,
                        color: ColorsManger.darkPrimary,
                        textSize: 18,
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cubit.pickFile();
                  },
                  child: Container(
                    height: SizeConfigManger.bodyHeight * .08,
                    width: SizeConfigManger.screenWidth * .22,
                    decoration: BoxDecoration(
                        color: ColorsManger.darkPrimary,
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenHeight(15))),
                    child: Center(
                      child: AppText(
                        text: "Choose File",
                        color: Colors.white,
                        textSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfigManger.bodyHeight * .04),
          CareerDropDown(cubit),
          SizedBox(height: SizeConfigManger.bodyHeight * .1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfigManger.bodyHeight * .02),
            child: state is UploadAudioLoading
                ? const Center(
                    child: CustomLoading(),
                  )
                : CustomButton(
                    text: "Upload",
                    press: () {
                      if (cubit.audioFile == null) {
                        Fluttertoast.showToast(
                          msg: "Please Choose Audio File First",
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                        );
                      } else if (cubit.choosdLangModel == null) {
                        Fluttertoast.showToast(
                            msg: "Please Choose Language First",
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER);
                      } else {
                        cubit.uploadAudioFile(
                            audioPath: cubit.audioFile!.path,
                            audioLang:
                                "${cubit.choosdLangModel!.languageCode}.wav");
                      }
                    },
                  ),
          )
        ],
      ),
    );
  }

  EmotionModel _getEmotionModel({required String emo}) {
    switch (emo) {
      case "angry":
        return emojiList[0];
      case "sad":
        return emojiList[1];
      case "surprise":
        return emojiList[2];
      case "happy":
        return emojiList[3];
      case "neutral":
        return emojiList[4];
      default:
        return emojiList[4];
    }
  }
}
