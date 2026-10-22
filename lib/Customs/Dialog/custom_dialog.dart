import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Widgets/BorderWidget/border_widget.dart';

void showCustomDialog({
  required String title,
  required String message,
  required String confirmText,
  required String cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  final isDark = Get.isDarkMode;

  Get.dialog(
    Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 250.w,
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // title
              Text(
                title,
                style: TextStyle(
                  fontFamily: constants.primaryFont,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              // message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: constants.primaryFont,
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              //border
              BorderWidget(),
              // confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    if (onConfirm != null) onConfirm();
                  },
                  // confirm text
                  child: Text(confirmText, style: TextStyle(color: Colors.red)),
                ),
              ),
              // border
              BorderWidget(),

              // cancel button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    if (onCancel != null) onCancel();
                  },
                  // confirm text
                  child: Text(
                    cancelText,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
