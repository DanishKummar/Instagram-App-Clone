import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Utils/Constants/constants.dart';

// ignore: must_be_immutable
class TextbuttonWidget extends StatelessWidget {
  String buttonText;
  VoidCallback voidCallback;
  TextbuttonWidget({
    super.key,
    required this.buttonText,
    required this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    Constants constants = Get.put(Constants());
    return TextButton(
      // onpress functionality
      onPressed: voidCallback,
      child: Text(
        buttonText,
        style: TextStyle(
          color: constants.textButtonColor,
          fontSize: 17.sp,
          // fontFamily: constants.primaryFont,
        ),
      ),
    );
  }
}
