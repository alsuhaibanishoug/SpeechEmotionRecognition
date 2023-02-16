// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/layout_un_registerd/layout_un_registerd.dart';
import 'package:saghi/main_layout/cubit/main_cubit.dart';
import 'package:saghi/screens/auth/login/cubit/login_cubit.dart';
import 'package:saghi/screens/auth/login/login_screen.dart';
import 'package:saghi/screens/auth/register/register_screen.dart';
import 'package:saghi/screens/darwer/fav_screen/widget/fav_item_design.dart';
import 'package:saghi/screens/darwer/guide_screen/guidelines%20_screen.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:saghi/widget/custom_button.dart';
import 'package:saghi/widget/custom_loading.dart';
import 'package:saghi/widget/custom_text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main_layout/main_layout.dart';
import '../../../shared/helper/methods.dart';
import '../../auth/forget_password/forget_password.dart';

class ProfileScreen extends StatelessWidget {
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  bool isFromMain;
  var formKey = GlobalKey<FormState>();
  var pageController = PageController(initialPage: 0);

  ProfileScreen(this.isFromMain, {super.key});

  @override
  Widget build(BuildContext context) {
    if (isFromMain) {
      return BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          if (state is UpdateProfileInfo) {
            FocusManager.instance.primaryFocus?.unfocus();
            pageController.previousPage(
                duration: const Duration(microseconds: 200),
                curve: Curves.fastLinearToSlowEaseIn);
          }
        },
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
          return cubit.userModel != null
              ? PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfigManger.bodyHeight * .02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfigManger.bodyHeight * .02),
                            InkWell(
                                onTap: () => pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.fastLinearToSlowEaseIn),
                                child: AppText(
                                    text: "Edit",
                                    color: ColorsManger.darkPrimary,
                                    fontWeight: FontWeight.bold,
                                    textSize: 24,
                                    textDecoration: TextDecoration.underline)),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * .02,
                            ),
                            Image.asset(
                              "assets/images/personal.png",
                              color: Colors.black,
                              fit: BoxFit.cover,
                              height: SizeConfigManger.bodyHeight * .15,
                              width: SizeConfigManger.bodyHeight * .15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfigManger.bodyHeight * .02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text:
                                        "${cubit.userModel!.firstName} ${cubit.userModel!.lastName}",
                                    textSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AppText(
                                    text: "${cubit.userModel!.email}",
                                    textSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfigManger.bodyHeight * .02),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                            InkWell(
                              onTap: () {
                                cubit.getAllFavResult();
                                pageController.animateToPage(4,
                                    duration: Duration(milliseconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppText(
                                          text: "History",
                                          fontWeight: FontWeight.bold,
                                          textSize: 20,
                                          color: Colors.black)),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                            InkWell(
                              onTap: () =>
                                  navigateTo(context, GuidelinesScreen()),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppText(
                                          text: "How to use SAGHI",
                                          fontWeight: FontWeight.bold,
                                          textSize: 20,
                                          color: Colors.black)),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                            InkWell(
                              onTap: () => pageController.animateToPage(3,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.fastLinearToSlowEaseIn),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppText(
                                          text: "Contact us",
                                          fontWeight: FontWeight.bold,
                                          textSize: 20,
                                          color: Colors.black)),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                            InkWell(
                              onTap: () => pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.fastLinearToSlowEaseIn),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppText(
                                          text: "About us",
                                          fontWeight: FontWeight.bold,
                                          textSize: 20,
                                          color: Colors.black)),
                                  const Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                navigateToAndFinish(
                                    context, const LayoutUnRegisterd());
                                showToast(
                                  msg: "Sign out successfully",
                                  color: Colors.green,
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: AppText(
                                          text: "Sign out",
                                          fontWeight: FontWeight.bold,
                                          textSize: 20,
                                          color: Colors.black)),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfigManger.bodyHeight * .02),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.fastLinearToSlowEaseIn),
                              child: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.arrow_back,
                                      color: Color.fromRGBO(68, 84, 106, 100))),
                            ),
                            SizedBox(height: SizeConfigManger.bodyHeight * .1),
                            GestureDetector(
                              onTap: () => cubit.pickUserImage(),
                              child: CircleAvatar(
                                radius: getProportionateScreenHeight(60),
                                backgroundColor: ColorsManger.darkPrimary,
                                backgroundImage: cubit.userModel!.image ==
                                        ConstantsManger.defaultValue
                                    ? const AssetImage(AssetsManger.profile)
                                    : NetworkImage(cubit.userModel!.image)
                                        as ImageProvider,
                              ),
                            ),
                            SizedBox(height: SizeConfigManger.bodyHeight * .04),
                            CustomTextFormField(
                              controller: firstName
                                ..text = cubit.userModel!.firstName,
                              type: TextInputType.text,
                              hintText: "First name",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "First name is required";
                                }
                              },
                            ),
                            SizedBox(
                                height: SizeConfigManger.bodyHeight * 0.04),
                            CustomTextFormField(
                              controller: lastName
                                ..text = cubit.userModel!.lastName,
                              type: TextInputType.text,
                              hintText: "Last name",
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "Last name is required";
                                }
                              },
                            ),
                            SizedBox(
                                height: SizeConfigManger.bodyHeight * 0.04),
                            CustomButton(
                                text: "Save Changes",
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.updateUserInfo(
                                        first: firstName.text,
                                        last: lastName.text);
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .04,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.fastLinearToSlowEaseIn),
                                child: const Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(Icons.arrow_back,
                                        color: Color.fromRGBO(68, 84, 106, 1))),
                              ),
                              SizedBox(
                                  width: SizeConfigManger.bodyHeight * .12),
                              AppText(
                                  text: "About Saghi",
                                  fontWeight: FontWeight.w700,
                                  color: ColorsManger.darkPrimary,
                                  textSize: 30),
                            ],
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .04),
                          AppText(
                              color: ColorsManger.darkPrimary,
                              maxLines: 100,
                              fontWeight: FontWeight.w500,
                              textSize: 22,
                              text:
                                  "Saghi is an application designed to help hearing-impaired people understand a speaker's emotional state during communication (by communicating in real time or attaching an audio file) by evaluating and displaying the speaker's emotional state in voice notes (happy, neutral, sad, etc.) as well as a transcript of it."),
                          SizedBox(height: SizeConfigManger.bodyHeight * .04),
                          Image.asset(
                            AssetsManger.logo,
                            height: SizeConfigManger.bodyHeight * .3,
                            width: SizeConfigManger.bodyHeight * .3,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .04,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.fastLinearToSlowEaseIn),
                                child: const Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(Icons.arrow_back,
                                        color: Color.fromRGBO(68, 84, 106, 1))),
                              ),
                              SizedBox(
                                  width: SizeConfigManger.bodyHeight * .13),
                              AppText(
                                  text: "Contact us",
                                  fontWeight: FontWeight.w700,
                                  color: ColorsManger.darkPrimary,
                                  textSize: 30),
                            ],
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () => _launchInBrowser(
                                      Uri.parse("www.facebook.com/saghi")),
                                  child: Image.asset(
                                    AssetsManger.facebook,
                                    height: SizeConfigManger.bodyHeight * .1,
                                    width: SizeConfigManger.bodyHeight * 0.1,
                                  )),
                              SizedBox(width: SizeConfigManger.bodyHeight * .1),
                              InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    AssetsManger.twitter,
                                    height: SizeConfigManger.bodyHeight * .1,
                                    width: SizeConfigManger.bodyHeight * 0.1,
                                  )),
                            ],
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .05),
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
                              SizedBox(width: SizeConfigManger.bodyHeight * .1),
                              InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    AssetsManger.tiktok,
                                    height: SizeConfigManger.bodyHeight * .1,
                                    width: SizeConfigManger.bodyHeight * 0.1,
                                  )),
                            ],
                          ),
                          SizedBox(height: SizeConfigManger.bodyHeight * .05),
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
                              SizedBox(width: SizeConfigManger.bodyHeight * .1),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .04,
                      ),
                      child: cubit.resultFavList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfigManger.bodyHeight * .02),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => pageController
                                            .animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 10),
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn),
                                        child: const Align(
                                            alignment:
                                                AlignmentDirectional.topStart,
                                            child: Icon(Icons.arrow_back,
                                                color: Color.fromRGBO(
                                                    68, 84, 106, 1))),
                                      ),
                                      SizedBox(
                                          width: SizeConfigManger.bodyHeight *
                                              .15),
                                      AppText(
                                          text: "History",
                                          fontWeight: FontWeight.w700,
                                          color: ColorsManger.darkPrimary,
                                          textSize: 30),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          SizeConfigManger.bodyHeight * .05),
                                  Expanded(
                                    child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            FavItemDesign(
                                                model:
                                                    cubit.resultFavList[index],
                                                cubit: cubit),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                                height: SizeConfigManger
                                                        .bodyHeight *
                                                    .02),
                                        itemCount: cubit.resultFavList.length),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => pageController.animateToPage(
                                          0,
                                          duration:
                                              const Duration(milliseconds: 10),
                                          curve: Curves.fastLinearToSlowEaseIn),
                                      child: const Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: Icon(Icons.arrow_back,
                                              color: Color.fromRGBO(
                                                  68, 84, 106, 1))),
                                    ),
                                    SizedBox(
                                        width:
                                            SizeConfigManger.bodyHeight * .15),
                                    AppText(
                                        text: "History",
                                        fontWeight: FontWeight.w700,
                                        color: ColorsManger.darkPrimary,
                                        textSize: 30),
                                  ],
                                ),
                                SizedBox(
                                    height: SizeConfigManger.bodyHeight * .4),
                                AppText(
                                  text: "No saved result",
                                  textSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                    ),
                  ],
                )
              : const CustomLoading();
        },
      );
    } else {
      return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            showToast(
              msg: state.errorMsg,
              color: Colors.red,
            );
          } else if (state is LoginSuccess) {
            showToast(
              msg: "Sign in successfully",
              color: Colors.green,
            );
            navigateToAndFinish(context, MainLayout());
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * .04),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                        Image.asset(
                          AssetsManger.logo,
                          height: SizeConfigManger.bodyHeight * .25,
                          width: SizeConfigManger.bodyHeight * .25,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                        AppText(
                            text: "Sign in to Saghi",
                            color: ColorsManger.darkPrimary,
                            fontWeight: FontWeight.bold),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomTextFormField(
                            controller: email,
                            type: TextInputType.emailAddress,
                            hintText: "Email",
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "Email address is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.02),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomTextFormField(
                            controller: password,
                            type: TextInputType.visiblePassword,
                            isPassword: true,
                            hintText: "Password",
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "Password is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.06),
                        state is LoginLoading
                            ? const CustomLoading()
                            : CustomButton(
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.signIn(
                                        email: email.text,
                                        password: password.text);
                                  }
                                },
                                text: "Sign in",
                              ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        GestureDetector(
                          onTap: () =>
                              navigateTo(context, ForgetpasswordScreen()),
                          child: AppText(
                              text: "Forget password?",
                              color: ColorsManger.orangePrimary,
                              textDecoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                            )),
                            GestureDetector(
                              onTap: () =>
                                  navigateTo(context, RegisterScreen()),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenHeight(10)),
                                child: AppText(
                                    text: "create account",
                                    color: ColorsManger.darkPrimary,
                                    textDecoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
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
