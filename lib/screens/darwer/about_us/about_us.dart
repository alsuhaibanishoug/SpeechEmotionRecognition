import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfigManger.bodyHeight * .04,
              vertical: SizeConfigManger.bodyHeight * .1),
          child: Column(
            children: [
              AppText(
                  text: "Saghi",
                  fontWeight: FontWeight.w700,
                  color: ColorsManger.darkPrimary,
                  textSize: 30),
              SizedBox(height: SizeConfigManger.bodyHeight * .04),
              AppText(
                  color: ColorsManger.darkPrimary,
                  maxLines: 100,
                  fontWeight: FontWeight.w500,
                  textSize: 22,
                  text:
                      "SAGHI is an application designed to help hearing-impaired people understand a speaker's emotional state during communication (by communicating in real time or attaching an audio file) by evaluating and displaying the speaker's emotional state in voice notes (happy, neutral, sad, etc.) as well as a transcript of it."),
              SizedBox(height: SizeConfigManger.bodyHeight * .04),
              Image.asset(
                AssetsManger.logo,
                height: SizeConfigManger.bodyHeight * .3,
                width: SizeConfigManger.bodyHeight * .3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
