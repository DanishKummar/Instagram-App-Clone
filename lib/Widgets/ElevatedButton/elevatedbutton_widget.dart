import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Utils/Constants/constants.dart';

// ignore: must_be_immutable
class ElevatedbuttonWidget extends StatelessWidget {
  String buttonText;
  VoidCallback callback;
  ElevatedbuttonWidget({
    super.key,
    required this.buttonText,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    // Data from constants class
    Constants constants = Get.put(Constants());

    return SizedBox(
      width: double.infinity, // Button takes full width of the parent container
      height: 50.h, // Responsive button height (7% of screen height)
      // Elevated button
      child: Obx(
        () => ElevatedButton(
          // Elevated button styling
          style: ElevatedButton.styleFrom(
            backgroundColor: constants.onlickColor, // Button background color

            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                25.r,
              ), // Responsive border radius
            ),
          ),
          // Elevated button onPress functionality
          onPressed: callback, // Add functionality here
          // Elevated button text
          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily:
                  constants.primaryFont, // Custom font from constants class
              fontWeight: FontWeight.bold, // Bold text
              fontSize: 18.sp, // Responsive text size using screenutil
            ),
          ),
        ),
      ),
    );
  }
}
