import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/screens/darwer/guide_screen/cubit/guideliness_cubit.dart';
import 'package:saghi/shared/helper/mangers/colors.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/widget/app_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'widget/custom_page_view.dart';

class GuidelinesScreen extends StatelessWidget {
  var boardController = PageController();
  int currentPage = 0;

  GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GuidelinessCubit>(
      create: (context) => GuidelinessCubit(),
      child: BlocConsumer<GuidelinessCubit, GuidelinessState>(
        listener: (context, state) {},
        builder: (context, state) {
          GuidelinessCubit cubit = GuidelinessCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: AppText(
                  text: "Guidelines",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  textSize: 22),
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
                    BottomNavigationBar(
                      items: cubit.bottomNavItems,
                      currentIndex: cubit.currentIndex,
                    ),
                    SizedBox(height: SizeConfigManger.bodyHeight * .1),
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) {
                          cubit.changeCurrentIndex(index);
                          if (index == splashData.length - 1) {
                            GuidelinessCubit.get(context)
                                .changePageViewState(true);
                          } else {
                            GuidelinessCubit.get(context)
                                .changePageViewState(false);
                          }
                        },
                        physics: const BouncingScrollPhysics(),
                        controller: boardController,
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => CustomPageView(
                            title: "${splashData[index]["title"]}",
                            text: "${splashData[index]["details"]}"),
                      ),
                    ),
                    SizedBox(height: SizeConfigManger.bodyHeight * .04),
                    SmoothPageIndicator(
                      controller: boardController,
                      count: splashData.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: ColorsManger.darkPrimary,
                        dotHeight: 10,
                        expansionFactor: 4,
                        dotWidth: 10,
                        spacing: 5.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (true) {
                          boardController.nextPage(
                              duration: const Duration(
                                milliseconds: 750,
                              ),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
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
          );
        },
      ),
    );
  }

  List<Map<String, String>> splashData = [
    {
      "title": "Text to speech icon",
      "details":
          "You will be taken to a Text to Speech page, there you can write a text that will be converted into an audio speech."
    },
    {
      "title": "Speech to text icon",
      "details":
          "You will be taken to a  Speech to text page, there you can record a real-time audio or upload an audio file that will be converted into a text."
    },
    {
      "title": "Personal account icon ",
      "details": "from this icon, you can edit your profile."
    },
  ];
}
