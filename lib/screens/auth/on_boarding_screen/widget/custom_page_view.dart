import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';

import '../../../../shared/helper/mangers/colors.dart';
class CustomPageViewOnBoarding extends StatelessWidget {
  String title;
  String text;


  CustomPageViewOnBoarding({required this.title,required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
            text: title,
            color:const Color(0xffE4750D),
            textSize: 24,
            fontWeight: FontWeight.w600),
        SizedBox(height: SizeConfigManger.bodyHeight * .02),
        AppText(
            text: text,
            color: ColorsManger.darkPrimary,
            textSize: 22,
            maxLines: 6,
            align: TextAlign.center,
            fontWeight: FontWeight.w400),
        const Spacer(),
      ],
    );
  }
}
