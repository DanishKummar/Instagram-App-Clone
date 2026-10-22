import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable boolean for theme
  var isDarkMode = true.obs;

  // Function to toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    // Set system icons brightness based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness: isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: isDarkMode.value
            ? Colors.black
            : Colors.white, // Keep status bar transparent
        systemNavigationBarColor: isDarkMode.value ? Colors.black : Colors.red,
      ),
    );

    // Change the app theme dynamically
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
