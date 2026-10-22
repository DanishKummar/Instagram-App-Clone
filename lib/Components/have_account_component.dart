import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Utils/Constants/constants.dart';

// ignore: must_be_immutable
class HaveaccountComponent extends StatelessWidget {
  String text;
  String buttonText;
  VoidCallback? onPress;
  HaveaccountComponent({
    super.key,
    required this.text,
    required this.buttonText,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    // data from constants class
    Constants constants = Get.put(Constants());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // text
        Text(
          text,
          // text styling
          style: TextStyle(
            color: const Color.fromARGB(255, 129, 129, 129),
            fontSize: 17.sp,
            fontFamily: constants.primaryFont,
          ),
        ),
        // text button
        TextButton(
          // go to sign up page functionality
          onPressed: onPress,
          child: Text(
            buttonText,
            // text button styling
            style: TextStyle(
              color: constants.textButtonColor,
              fontSize: 17.sp,
              fontFamily: constants.primaryFont,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
