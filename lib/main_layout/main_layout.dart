import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saghi/main_layout/cubit/main_cubit.dart';
import 'package:saghi/screens/darwer/guide_screen/guidelines%20_screen.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';
import 'package:saghi/shared/helper/methods.dart';
import 'package:showcaseview/showcaseview.dart';
import '../models/language_model.dart';
import '../screens/layout/text_to_speed/widgets/text_to_speech_guideline.dart';
import '../shared/helper/mangers/colors.dart';
import '../widget/app_text.dart';
import '../widget/drawer_design.dart';

class MainLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return BlocProvider(
      create: (context) => MainCubit()..init(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
           // drawer: DrawerDesign(cubit: cubit),
            appBar: cubit.currentIndex == 0
                ? null
                : AppBar(
                    backgroundColor: Colors.white,
                    title: AppText(
                        text: cubit.titles[cubit.currentIndex],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        textSize: 22),
                    actions: [
                      Visibility(
                          visible: cubit.currentIndex == 0,
                          child: IconButton(
                              onPressed: () => navigateTo(
                                  context,
                                  ShowCaseWidget(
                                      builder: Builder(
                                          builder: (context) =>
                                              TffGuideLine()))),
                              icon: Icon(
                                Icons.help_center,
                                color: ColorsManger.darkPrimary,
                              )))
                      /*GestureDetector(
                  onTap: () => _scaffoldKey.currentState!.openDrawer(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.screenWidth * .03),
                    child: Icon(
                      size: SizeConfigManger.bodyHeight * .045,
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ),*/
                    ],
                    leading: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfigManger.bodyHeight * 0.02),
                      child: PopupMenuButton<LanguageModel>(
                          icon: Icon(Icons.language,
                              color: Colors.white,
                              size: SizeConfigManger.bodyHeight * .05),
                          onSelected: (LanguageModel item) async {
                            cubit.changeLanguage(langCode: item.languageCode);
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<LanguageModel>>[
                                PopupMenuItem<LanguageModel>(
                                  value: LanguageModel.choices[0],
                                  child: Row(
                                    children: [
                                      Text(LanguageModel.getCountryFlag('US')),
                                      SizedBox(
                                          width: SizeConfigManger.bodyHeight *
                                              .02),
                                      AppText(text: "English")
                                    ],
                                  ),
                                ),
                                PopupMenuItem<LanguageModel>(
                                  value: LanguageModel.choices[1],
                                  child: Row(
                                    children: [
                                      Text(LanguageModel.getCountryFlag('SA')),
                                      SizedBox(
                                          width: SizeConfigManger.bodyHeight *
                                              .02),
                                      AppText(text: "Arabic")
                                    ],
                                  ),
                                ),
                              ]),
                    ),
                  ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.changeCurrentIndex(index: index),
            ),
          );
        },
      ),
    );
  }
}
