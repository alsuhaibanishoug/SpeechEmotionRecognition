import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import '../../shared/helper/mangers/size_config.dart';

class AppText extends StatelessWidget {
  String text;
  Color? color;
  double? textSize;
  FontWeight? fontWeight;
  TextDecoration? textDecoration;
  TextAlign? align;
  int? maxLines;
  String? fontFamily;
  bool? isLogo;

  AppText({
    required this.text,
    this.color,
    this.textSize,
    this.fontWeight,
    this.maxLines,
    this.textDecoration,
    this.fontFamily,
    this.align,
    this.isLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        textAlign: align == null ? null : align,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontFamily: ConstantsManger.appFont,
              overflow: TextOverflow.ellipsis,
              decoration: textDecoration ?? null,
              color: color ?? Theme.of(context).textTheme.bodyText1!.color,
              fontSize: textSize==null ? getProportionateScreenHeight(20):getProportionateScreenHeight(textSize!),
              fontWeight: fontWeight == null ? FontWeight.w400 : fontWeight,
            ));
  }

}
