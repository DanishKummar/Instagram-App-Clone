import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
// import 'package:get/utils.dart';

class OrComponent extends StatelessWidget {
  const OrComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // constant class data
    Constants constants = Get.put(Constants());
    // ____________________ or ____________________
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // straight line (____________________)
        Expanded(
          child: Container(height: 2.h, color: constants.fieldBorderColor),
        ),
        // or--> text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "OR",
            style: TextStyle(
              color: const Color.fromARGB(255, 161, 161, 161),
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
            ),
          ),
        ),
        // // straight line (____________________)
        Expanded(
          child: Container(height: 2.h, color: constants.fieldBorderColor),
        ),
      ],
    );
  }
}
