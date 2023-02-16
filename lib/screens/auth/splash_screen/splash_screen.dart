import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:saghi/layout_un_registerd/layout_un_registerd.dart';
import 'package:saghi/main_layout/main_layout.dart';
import 'package:saghi/screens/auth/on_boarding_screen/on_boarding.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/shared/services/local/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManger.logo,
              height: SizeConfigManger.bodyHeight * .3,
              width: SizeConfigManger.bodyHeight * .3,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }

  void init() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      bool isOnBoarding =
          CachedHelper.getBooleon(key: ConstantsManger.onBoadring) ?? false;
      if (isOnBoarding) {
        FirebaseAuth.instance.authStateChanges().listen((event) {
          if (event == null) {
            if (mounted) {
              Future.delayed(const Duration(seconds: 2),
                  () => navigateToAndFinish(context, LayoutUnRegisterd()));
            }
          } else {
            if (mounted) {
              Future.delayed(const Duration(seconds: 2),
                  () => navigateToAndFinish(context, MainLayout()));
            }
          }
        });
      } else {
        if (mounted) {
          Future.delayed(const Duration(seconds: 2),
              () => navigateToAndFinish(context, OnBoardingScreen()));
        }
      }
    } else {
      showToast(
        msg: "Check your internet connection",
        color: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
