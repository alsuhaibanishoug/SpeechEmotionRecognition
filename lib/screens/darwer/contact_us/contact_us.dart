import 'package:flutter/material.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/helper/mangers/assets_manger.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

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
                  text: "Contact us by:",
                  fontWeight: FontWeight.w700,
                  color: ColorsManger.darkPrimary,
                  textSize: 30),
              SizedBox(height: SizeConfigManger.bodyHeight*.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () =>_launchInBrowser(Uri.parse("www.facebook.com/saghi")),
                      child: Image.asset(
                        AssetsManger.facebook,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                  SizedBox(width: SizeConfigManger.bodyHeight*.1),
                  InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AssetsManger.twitter,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                ],
              ),
              SizedBox(height: SizeConfigManger.bodyHeight*.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AssetsManger.link,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                  SizedBox(width: SizeConfigManger.bodyHeight*.1),
                  InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AssetsManger.tiktok,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                ],
              ),
              SizedBox(height: SizeConfigManger.bodyHeight*.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AssetsManger.snap,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                  SizedBox(width: SizeConfigManger.bodyHeight*.1),
                  InkWell(
                      onTap: () {},
                      child: Image.asset(
                        AssetsManger.insta,
                        height: SizeConfigManger.bodyHeight * .1,
                        width: SizeConfigManger.bodyHeight * 0.1,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
