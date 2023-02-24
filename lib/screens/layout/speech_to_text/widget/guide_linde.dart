import 'package:flutter/material.dart';
import 'package:saghi/models/language_model.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/show_case_view.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../shared/helper/mangers/colors.dart';

class GuideLineSpeechToText extends StatefulWidget {
  const GuideLineSpeechToText({Key? key}) : super(key: key);

  @override
  State<GuideLineSpeechToText> createState() => _GuideLineSpeechToTextState();
}

class _GuideLineSpeechToTextState extends State<GuideLineSpeechToText> {
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context)
          .startShowCase([globalKeyOne, globalKeyTwo, globalKeyThree]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsetsDirectional.only(top: 10, start: 10),
          child: Container(
            alignment: AlignmentDirectional.topStart,
            child: ShowCaseView(
              title: "Upload icon",
              globalKey: globalKeyThree,
              description: "Upload an audio file you want analyze.",
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
              onPressed: () {},
              icon: Icon(
                Icons.help_center,
                color: ColorsManger.darkPrimary,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: SizeConfigManger.bodyHeight * .45),
          AppText(text: "Tap To Record", textSize: 20),
          SizedBox(height: SizeConfigManger.bodyHeight * .02),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 80),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowCaseView(
                  title: "Record icon",
                  description:
                      "Tap the microphone and start real-time recording.",
                  globalKey: globalKeyTwo,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManger.darkPrimary,
                    ),
                    child: const Icon(Icons.mic, size: 60, color: Colors.white),
                  ),
                ),
                SizedBox(width: SizeConfigManger.bodyHeight * .05),
                ShowCaseView(
                  globalKey: globalKeyOne,
                  description:
                      "Choose the language of your audio( Arabic or English).",
                  title: "Language icon",
                  child: PopupMenuButton<LanguageModel>(
                      icon: Image.asset('assets/icons/lang.png'),
                      onSelected: (LanguageModel item) async {},
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
