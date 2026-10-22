import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Utils/Constants/constants.dart';

// ignore: must_be_immutable
class TextfieldWidget extends StatelessWidget {
  String hintText;
  bool obscureText;
  TextInputType inputType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  TextfieldWidget({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // constants controller
    Constants constants = Get.put(Constants());
    // text field container
    return Obx(
      () => Container(
        // text container width
        width: double.infinity,
        // height: MediaQuery.of(context).size.height * 0.07,
        height: 50.h,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          // container border styling
          border: Border.all(
            color: constants.fieldBorderColor,
            width: 1,
            style: BorderStyle.solid,
          ),
          // text field container color
          color: constants.textFieldBackground,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Obx(
          () => TextField(
            onChanged: onChanged,
            controller: controller,
            // focusNode: focusNode,
            keyboardType: inputType,
            obscureText: obscureText,
            // text field inpout decoration
            decoration: InputDecoration(
              // side border none
              border: OutlineInputBorder(borderSide: BorderSide.none),

              hintText: hintText,
              // hint text styling
              hintStyle: TextStyle(
                fontFamily: constants.primaryFont,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                // hint text color
                color: constants.hintColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
