import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:saghi/shared/helper/mangers/assets_manger.dart';
import 'package:saghi/shared/helper/mangers/size_config.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static OnboardingCubit get(context)=>BlocProvider.of(context);



  bool isLast = false;
  int currentPage = 0;
  void changePageViewState(bool from , int page) {
    isLast = from;
    currentPage = page;
    emit(LastPageView());
  }

  int currentIndex = 0;

  void changeCurrentIndex(index){
    currentIndex = index;
    emit(ChangeGuideIndexState());
  }

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      activeIcon: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Image.asset(
          AssetsManger.speacker,
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenHeight(40),
        ),
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
      activeIcon: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Image.asset(
          AssetsManger.mic,
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenHeight(40),
        ),
      ),
      icon: Image.asset(
        AssetsManger.mic,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      activeIcon: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Image.asset(
          AssetsManger.profile,
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenHeight(40),
        ),
      ),
      icon: Image.asset(
        AssetsManger.profile,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: Colors.white,
      ),
      label: "",
    ),
  ];

}
