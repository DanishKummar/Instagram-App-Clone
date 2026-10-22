import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBottomSheet {
  static void show({
    required Widget child,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    Get.bottomSheet(
      // bottom sheet container
      Container(
        padding: EdgeInsets.all(16.w),
        height: height ?? 300.h,
        width: double.infinity,
        // box decoration
        decoration: ShapeDecoration(
          color: Color(0xFF222328),
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
        ),
        // bottom sheet widget
        child: child,
      ),
      // dismissible
      isDismissible: isDismissible,
      // drag
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
    );
  }
}
