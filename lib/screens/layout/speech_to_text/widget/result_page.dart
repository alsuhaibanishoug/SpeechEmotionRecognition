import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saghi/layout_un_registerd/layout_un_registerd.dart';
import 'package:saghi/main_layout/main_layout.dart';
import 'package:saghi/models/audio_model.dart';
import 'package:saghi/screens/layout/speech_to_text/cubit/speech_cubit.dart';
import 'package:saghi/screens/layout/speech_to_text/speech_to_text.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/emotion_deisgn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../models/emotion_model.dart';

class ResultScreen extends StatelessWidget {
  SpeechCubit cubit;
  bool isRegisterd;
  
  ResultScreen(this.cubit, this.isRegisterd);

  @override
  Widget build(BuildContext context) {
    if (isRegisterd) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfigManger.bodyHeight * .02),
                Container(
                  height: SizeConfigManger.bodyHeight * .25,
                  padding: const EdgeInsets.all(20),
                  width: SizeConfigManger.screenWidth * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(20))),
                  child: SingleChildScrollView(
                    child: AppText(
                      color: Colors.black,
                      textSize: 22,
                      maxLines: 20,
                      text: '${cubit.responseModel!.text}',
                    ),
                  ),
                ),
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
                EmotionDesign(cubit.emotionModel!),
                SizedBox(height: SizeConfigManger.bodyHeight * .02),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfigManger.bodyHeight * .02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(20))),
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
                            dataSource: cubit.listEmotionModel,
                            xValueMapper: (EmotionModel model, _) =>
                                model.title,
                            yValueMapper: (EmotionModel model, _) =>
                                model.value,
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
                SizedBox(height: SizeConfigManger.bodyHeight * .02),
                Visibility(
                  visible: FirebaseAuth.instance.currentUser != null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                AudioModel model = AudioModel(
                                  id: ConstantsManger.defaultValue,
                                  text: cubit.responseModel!.text,
                                  sad: cubit.responseModel!.sad,
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  surprise: cubit.responseModel!.surprise,
                                  angry: cubit.responseModel!.angry,
                                  happy: cubit.responseModel!.happy,
                                  neutral: cubit.responseModel!.neutral,
                                );
                                FirebaseFirestore.instance
                                    .collection(ConstantsManger.FAV)
                                    .add(model.toMap())
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection(ConstantsManger.FAV)
                                      .doc(value.id)
                                      .update({"id": value.id});
                                });

                                Fluttertoast.showToast(
                                  msg: "Add To Favourite Successfully",
                                  backgroundColor: Colors.green,
                                );
                                navigateToAndFinish(context, MainLayout());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManger.darkPrimary,
                                ),
                                child: const Icon(Icons.thumb_up_alt_rounded,
                                    color: Colors.white),
                              ),
                            ),
                            AppText(text: "Keep")
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async => navigateToAndFinish(context,
                                  MainLayout()), //Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManger.darkPrimary,
                                ),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                            ),
                            AppText(text: "Discard"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: SizeConfigManger.bodyHeight * .02),
              Row(
                children: [
                  SizedBox(width: SizeConfigManger.screenWidth * .03),
                  InkWell(
                    onTap: () =>
                        navigateToAndFinish(context, const LayoutUnRegisterd()),
                    child: const Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.arrow_back,
                            color: Color.fromRGBO(68, 84, 106, 1))),
                  ),
                ],
              ),
              Container(
                height: SizeConfigManger.bodyHeight * .25,
                padding: const EdgeInsets.all(20),
                width: SizeConfigManger.screenWidth * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(20))),
                child: AppText(
                  color: Colors.black,
                  maxLines: 20,
                  textSize: 22,
                  text: "${cubit.responseModel!.text}",
                ),
              ),
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
              EmotionDesign(cubit.emotionModel!),
              SizedBox(height: SizeConfigManger.bodyHeight * .02),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfigManger.bodyHeight * .02),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(20))),
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
                          dataSource: cubit.listEmotionModel,
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
              SizedBox(height: SizeConfigManger.bodyHeight * .02),
/*
                Visibility(
                  visible: FirebaseAuth.instance.currentUser == null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                AudioModel model = AudioModel(
                                    ConstantsManger.defaultValue,
                                    FirebaseAuth.instance.currentUser!.uid,
                                    true,
                                    cubit.responseModel!.text);
                                FirebaseFirestore.instance
                                    .collection(ConstantsManger.FAV)
                                    .add(model.toMap())
                                    .then((value) {
                                  FirebaseFirestore.instance
                                      .collection(ConstantsManger.FAV)
                                      .doc(value.id)
                                      .update({"id": value.id});
                                });

                                Fluttertoast.showToast(
                                    msg: "Add To Favourite Successfully");
                                navigateToAndFinish(context, MainLayout());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManger.darkPrimary,
                                ),
                                child: Image.asset("assets/images/keep.png"),
                              ),
                            ),
                            AppText(text: "Keep")
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManger.darkPrimary,
                                ),
                                child: Image.asset("assets/images/remove.png"),
                              ),
                            ),
                            AppText(text: "Discard"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
*/
            ],
          ),
        ),
      );
    }
  }
}
