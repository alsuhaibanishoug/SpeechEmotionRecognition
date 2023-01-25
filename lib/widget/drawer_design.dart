/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saghi/screens/darwer/about_us/about_us.dart';
import 'package:saghi/screens/darwer/fav_screen/fav_screen.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';

import '../main_layout/cubit/main_cubit.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/darwer/contact_us/contact_us.dart';
import '../screens/darwer/guide_screen/guidelines _screen.dart';
import '../shared/helper/mangers/colors.dart';
import '../shared/helper/methods.dart';
import 'app_text.dart';

class DrawerDesign extends StatelessWidget {
  final MainCubit cubit;

  const DrawerDesign({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: ColorsManger.darkPrimary,
        child: ListView(children: [
          DrawerHeader(
            child: Column(
              children: [
                SizedBox(height: SizeConfigManger.bodyHeight * .02),
                Image.asset(
                  AssetsManger.profile,
                ),
                SizedBox(height: SizeConfigManger.bodyHeight * .05),
                AppText(
                    text: "Username",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    textSize: 24),
              ],
            ),
          ),
          buildCustomItem(
              title: "Favorite", onTap: () => navigateTo(context, FavScreen())),
          const Divider(
            color: Colors.white,
          ),
          buildCustomItem(title: "Language", onTap: () {}),
          const Divider(
            color: Colors.white,
          ),
          buildCustomItem(
              title: "How to use SAGHI",
              onTap: () => navigateTo(context, GuidelinesScreen())),
          const Divider(
            color: Colors.white,
          ),
          buildCustomItem(
              title: "Contact us",
              onTap: () => navigateTo(context, const ContactUsScreen())),
          const Divider(
            color: Colors.white,
          ),
          buildCustomItem(
              title: "About us",
              onTap: () => navigateTo(context, const AboutUsScreen())),
          const Divider(
            color: Colors.white,
          ),
          buildCustomItem(title: "Sign out ",
            onTap: ()async{
              await FirebaseAuth.instance.signOut();
              navigateToAndFinish(context, LoginScreen());
            },

          ),
        ]));
  }

  Widget buildCustomItem({required String title, required onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfigManger.screenWidth * 0.02),
        child: Row(
          children: [
            AppText(
                text: title,
                color: Colors.white,
                textSize: 24,
                fontWeight: FontWeight.w500),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
*/
