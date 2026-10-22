// constants controller
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/ThemeController/theme_controller.dart';

ThemeController themeController = Get.find();

class Constants extends GetxController {
  //  App-wide constants
  final String appName = "Instagram";
  final String apiUrl = "https://api.example.com";
  // app logo for login

  // font families
  // final String primaryFont = "ProximaNova";
  final String primaryFont = "Sfpro";
  // text field color
  final Color fieldColor = Color(0xFFfafafa);
  // text field hint text color
  Color get hintColor => themeController.isDarkMode.value
      ? const Color.fromARGB(255, 126, 126, 126)
      : const Color.fromARGB(255, 202, 202, 202);
  //  // text button color
  final textButtonColor = Color(0xFF4d97ef);
  // elevated on press button background color
  Color get onlickColor => themeController.isDarkMode.value
      ? const Color.fromARGB(255, 11, 15, 247)
      : Color(0xFF3797EF);
  final Color facebookColor = Color(0xFF468ada);
  // text field background color
  Color get textFieldBackground =>
      themeController.isDarkMode.value ? Color(0xFF121212) : Color(0xFFfafafa);
  // text field border color
  Color get fieldBorderColor =>
      themeController.isDarkMode.value ? Color(0xFF414141) : Color(0xFFe1e1e1);
  Color get navigationBgColor =>
      themeController.isDarkMode.value ? Colors.black : Color(0xFFfafafa);
  Color get navigationBorderColor => themeController.isDarkMode.value
      ? const Color.fromARGB(255, 63, 63, 63)
      : Colors.black;
}
