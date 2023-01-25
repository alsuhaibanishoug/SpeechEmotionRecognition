import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/mangers/colors.dart';

class ThemeManger {
  static ThemeData setLightTheme() {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorsManger.darkPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      primaryColor: ColorsManger.darkPrimary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
        iconTheme: IconThemeData(color: ColorsManger.darkPrimary),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorsManger.darkPrimary,
          primary: ColorsManger.darkPrimary),
    );
  }
}
