import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saghi/main_layout/cubit/main_cubit.dart';
import 'package:saghi/models/language_model.dart';
import 'package:saghi/screens/layout/text_to_speech/widgets/text_to_speech_guideline.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../shared/helper/mangers/assets_manger.dart';
import '../../../shared/helper/methods.dart';
import '../../../widget/app_text.dart';
import '../../../widget/custom_button.dart';
import 'widgets/bottom_sheet_design.dart';

class TextToSpeechScreen extends StatelessWidget {
  var text = TextEditingController();
  var formKey = GlobalKey<FormState>();

  TextToSpeechScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () => navigateTo(
                      context,
                      ShowCaseWidget(
                          builder:
                              Builder(builder: (context) => TffGuideLine()))),
                  icon: Icon(
                    Icons.help_center,
                    color: ColorsManger.darkPrimary,
                  ),
                ),
              ],
            ),
            body: Form(
              key: formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfigManger.bodyHeight * .02),
                    Container(
                      height: SizeConfigManger.bodyHeight * .4,
                      padding: const EdgeInsets.all(20),
                      width: SizeConfigManger.screenWidth * 0.8,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(
                              getProportionateScreenHeight(20))),
                      child: TextFormField(
                        controller: text,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        maxLines: 100,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Please Enter some text";
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter some text to convert...",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: cubit.soundUrl == null,
                      child: Column(children: [
                        SizedBox(height: SizeConfigManger.bodyHeight * .04),
                        Center(
                            child:
                                AppText(text: "Tap To Convert", textSize: 20)),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 80, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (cubit.lang == null) {
                                    Fluttertoast.showToast(
                                      msg: "please choose language first",
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                    );
                                  } else {
                                    if (formKey.currentState!.validate()) {
                                      cubit.createAudioScript(
                                          script: text.text);
                                      Fluttertoast.showToast(
                                        msg: "Your text is being converted",
                                        backgroundColor:
                                            ColorsManger.darkPrimary,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorsManger.darkPrimary,
                                  ),
                                  child: const Icon(Icons.change_circle,
                                      size: 80, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                  width: SizeConfigManger.bodyHeight * .05),
                              PopupMenuButton<LanguageModel>(
                                  icon: Image.asset('assets/icons/lang.png'),
                                  onSelected: (LanguageModel item) async {
                                    cubit.changeLanguage(
                                        langCode: item.languageCode);
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<LanguageModel>>[
                                        PopupMenuItem<LanguageModel>(
                                          value: LanguageModel.choices[0],
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: SizeConfigManger
                                                          .bodyHeight *
                                                      .02),
                                              AppText(text: "English")
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<LanguageModel>(
                                          value: LanguageModel.choices[1],
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: SizeConfigManger
                                                          .bodyHeight *
                                                      .02),
                                              AppText(text: "Arabic")
                                            ],
                                          ),
                                        ),
                                      ]),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Visibility(
                      visible: cubit.soundUrl != null,
                      child: Container(
                        margin: const EdgeInsets.all(30),
                        width: double.infinity,
                        height: SizeConfigManger.bodyHeight * .25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfigManger.bodyHeight * .02),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.fast_rewind_outlined)),
                                  Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black, width: 3)),
                                      child: IconButton(
                                          onPressed: () async {
                                            cubit.playSoundOrStopPlaying(
                                                soundLink: "${cubit.soundUrl}");
                                          },
                                          icon: Icon(cubit.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow))),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.fast_forward_outlined)),
                                  IconButton(
                                      onPressed: () async {
                                        Share.share("${cubit.soundUrl}");
                                      },
                                      icon: const Icon(
                                          Icons.file_upload_outlined)),
                                ],
                              ),
                            ),
                            Slider(
                                min: 0,
                                max: cubit.duration.inSeconds.toDouble(),
                                value: cubit.position.inSeconds.toDouble(),
                                onChanged: (value) =>
                                    cubit.changeSlider(value)),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                      text: cubit.formatTime(
                                          cubit.position.inSeconds)),
                                  AppText(
                                      text: cubit.formatTime(
                                          (cubit.duration - cubit.position)
                                              .inSeconds)),
                                ],
                              ),
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
        },
      ),
    );
  }
}
