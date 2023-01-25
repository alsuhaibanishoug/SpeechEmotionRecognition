import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/layout_un_registerd/layout_un_registerd.dart';
import 'package:saghi/screens/auth/on_boarding_screen/cubit/onboarding_cubit.dart';
import 'package:saghi/screens/darwer/guide_screen/cubit/guideliness_cubit.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/constants.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:saghi/shared/services/local/cache_helper.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'widget/custom_page_view.dart';


class OnBoardingScreen extends StatelessWidget {
  var boardController = PageController(initialPage: 0);
  int currentPage = 0;

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          OnboardingCubit cubit = OnboardingCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: AppText(
                  text: "Guidelines",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  textSize: 22),
              actions: [
                cubit.currentPage != 3 ?
                IconButton(onPressed: () {},
                    icon: Icon(Icons.help_center, color: ColorsManger.grey)):
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300]
                  ),
                  child: IconButton(onPressed: () {},
                      icon: Icon(Icons.help_center, color: ColorsManger.darkPrimary)),
                )
              ],
            ),
            body: Center(
              child: Container(
                height: SizeConfigManger.bodyHeight * .7,
                width: SizeConfigManger.screenWidth * .9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorsManger.darkPrimary),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfigManger.bodyHeight * .1),
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) {
                          print(index);
                          if (index != 3) {
                            cubit.changeCurrentIndex(index);
                          }
                          if (index == splashData.length - 1) {
                            OnboardingCubit.get(context).changePageViewState(
                                true, index);
                          } else {
                            OnboardingCubit.get(context).changePageViewState(
                                false, index);
                          }
                        },
                        physics: const BouncingScrollPhysics(),
                        controller: boardController,
                        itemCount: splashData.length,
                        itemBuilder: (context, index) =>
                            CustomPageViewOnBoarding(
                                title: "${splashData[index]["title"]}",
                                text: "${splashData[index]["details"]}"),
                      ),
                    ),
                    SizedBox(height: SizeConfigManger.bodyHeight * .04),
                    SmoothPageIndicator(
                      controller: boardController,
                      count: splashData.length,
                      effect: SlideEffect(
                        dotColor: Colors.grey,
                        activeDotColor: ColorsManger.darkPrimary,
                        dotHeight: 10,
                        //  expansionFactor: 4,
                        dotWidth: 50,
                        spacing: 5.0,
                      ),
                    ),
                    SizedBox(height: SizeConfigManger.bodyHeight * .04),
                    cubit.currentPage == 3 ?
                    InkWell(
                      onTap: ()async {
                       await CachedHelper.saveBool(key: ConstantsManger.onBoadring, value: true);
                       navigateToAndFinish(context, const LayoutUnRegisterd());
                      },
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: SizeConfigManger.screenWidth * .3,
                          height: SizeConfigManger.bodyHeight * .08,
                          decoration: BoxDecoration(
                              color: ColorsManger.darkPrimary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: AppText(
                                text: "Close",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ) :
                    InkWell(
                      onTap: () {
                        boardController.nextPage(
                            duration: const Duration(
                              milliseconds: 750,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      },
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: SizeConfigManger.screenWidth * .3,
                          height: SizeConfigManger.bodyHeight * .08,
                          decoration: BoxDecoration(
                              color: ColorsManger.darkPrimary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: AppText(
                                text: "Skip",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Visibility(
              visible: cubit.currentPage != 3,
              child: BottomNavigationBar(
                items: cubit.bottomNavItems,
                currentIndex: cubit.currentIndex,
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> splashData = [
    {
      "title": "Text to speech icon",
      "details": "You will be taken to a Text to Speech page, there you can write a text that will be converted into an audio speech."
    },
    {
      "title": "Saghi icon",
      "details": "You will be taken to the home page, there you can record a real-time audio or upload an audio file that will be converted into a text."
    },
    {
      "title": "Account icon",
      "details": "You will be taken to your personal accaccount page (or a sign in/sign up page), there you can edit your profile and check your Keep results."
    },
    {
      "title": "Help Icon ",
      "details": "You will be taken through a tour of how to use the page you are at."
    },
  ];
}
