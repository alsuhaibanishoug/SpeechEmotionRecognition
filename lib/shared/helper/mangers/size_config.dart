import 'package:flutter/material.dart';

class SizeConfigManger {
  late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double statusBarHeight;
  static late String langCode;
  late double appBarHeight;
  static late double bodyHeight;
  static var brightness;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    statusBarHeight = mediaQueryData.padding.top;
    brightness = mediaQueryData.platformBrightness;
    appBarHeight = AppBar().preferredSize.height;
    bodyHeight = mediaQueryData.size.height - statusBarHeight - appBarHeight;
    langCode = Localizations.localeOf(context).languageCode;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfigManger.bodyHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfigManger.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

