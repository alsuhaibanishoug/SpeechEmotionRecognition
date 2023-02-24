import 'package:flutter/material.dart';
import 'package:saghi/screens/layout/profile/profile.dart';
import 'package:saghi/screens/layout/speech_to_text/speech_to_text.dart';
import 'package:saghi/screens/layout/text_to_speech/text_to_speech.dart';
import '../shared/helper/mangers/assets_manger.dart';
import '../shared/helper/mangers/size_config.dart';

class LayoutUnRegisterd extends StatefulWidget {
  const LayoutUnRegisterd({Key? key}) : super(key: key);

  @override
  State<LayoutUnRegisterd> createState() => _LayoutUnRegisterdState();
}

class _LayoutUnRegisterdState extends State<LayoutUnRegisterd> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return Scaffold(
      appBar: currentIndex == 2 ? AppBar() : null,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  List<Widget> screens = [
    TextToSpeechScreen(),
    SpeechToTextScreen(isFromMain: false),
    ProfileScreen(false),
  ];
}
