import 'package:flutter/material.dart';
import 'package:saghi/models/language_model.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/show_case_view.dart';
import 'package:showcaseview/showcaseview.dart';

class TffGuideLine extends StatefulWidget {
  const TffGuideLine({Key? key}) : super(key: key);

  @override
  State<TffGuideLine> createState() => _TffGuideLineState();
}

class _TffGuideLineState extends State<TffGuideLine> {
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context).startShowCase([globalKeyOne,globalKeyTwo]);
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
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
                  style: TextStyle(
                    fontSize: 22,
                    color: ColorsManger.darkPrimary,
                  ),
                  maxLines: 100,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "من فضلك قم بكتابه نص";
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
              SizedBox(height: SizeConfigManger.bodyHeight * .02),
              Center(child: AppText(text: "Tap To Convert", textSize: 20)),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShowCaseView(
                      globalKey: globalKeyTwo,
                      description: "Tap the icon to covert the text you written to an audio file.",
                      title: "Convert  icon",
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManger.darkPrimary,
                        ),
                        child: const Icon(Icons.change_circle, size: 90,color: Colors.white),
                      ),
                    ),
                    SizedBox(width: SizeConfigManger.bodyHeight*.05),
                    ShowCaseView(
                      description:"Choose the language of your text( Arabic or English)." ,
                      globalKey: globalKeyOne,
                      title: "Language icon",
                      child: PopupMenuButton<LanguageModel>(
                          icon: Image.asset('assets/icons/lang.png'),
                          onSelected: (LanguageModel item) async{
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<LanguageModel>>[
                            PopupMenuItem<LanguageModel>(
                              value: LanguageModel.choices[0],
                              child: Row(
                                children: [
                                  Text(LanguageModel.getCountryFlag('US')),
                                  SizedBox(width: SizeConfigManger.bodyHeight*.02),
                                  AppText(text: "English")
                                ],
                              ),
                            ),
                            PopupMenuItem<LanguageModel>(
                              value: LanguageModel.choices[1],
                              child: Row(
                                children: [
                                  Text(LanguageModel.getCountryFlag('SA')),
                                  SizedBox(width: SizeConfigManger.bodyHeight*.02),
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
        ),
      ),
    );
  }
}
