import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

ThemeData light = ThemeData(
  //backwardsCompatibility: false,
  //statusBarColor: Colors.white,
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:Get.isDarkMode ?  Brightness.light: Brightness.dark,
     statusBarColor:Get.isDarkMode ?  Colors.black : Colors.transparent
    ),
  ),
  fontFamily: 'Muli',
  primaryColor: Color(0xFFFFC403),
  secondaryHeaderColor: Color(0xFF1ED7AA),
  disabledColor: Color(0xFFBABFC4),
  backgroundColor: Color(0xFFF3F3F3),
  errorColor: Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: Color(0xFFEF7822), secondary: Color(0xFFEF7822)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Color(0xFFEF7822))),
);
//0xFFBABFC4