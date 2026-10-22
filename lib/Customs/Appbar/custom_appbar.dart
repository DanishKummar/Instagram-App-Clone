import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/AppBarController/appbar_controller.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';

AppbarController appbarController = Get.put(appbarController);

// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget {
  // title icon
  final bool showTitle;
  final Widget? title;
  // var title;
  // leading icon 1
  final bool showLeading;
  final leadingIcon;
  var leadingWidth;
  var leadingHeight;
  final VoidCallback? onLeadingPressed;
  // action 1 icon
  final bool showAction1;
  final IconData? actionIcon1;
  final VoidCallback? onAction1Pressed;
  // action 2 icon
  final bool showAction2;
  var actionIcon2;
  final VoidCallback? onAction2Pressed;
  CustomAppbar({
    this.title,
    this.showTitle = false,
    this.showLeading = false,
    require,
    this.leadingIcon,
    this.onLeadingPressed,
    this.actionIcon1,
    this.showAction1 = false,
    this.onAction1Pressed,
    this.showAction2 = false,
    this.actionIcon2,
    this.onAction2Pressed,
    this.leadingWidth,
    this.leadingHeight,
  });
  @override
  // Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title (always centered)
          if (showTitle)
            Padding(
              padding: EdgeInsets.only(top: 45.h),
              child: title,
            ),

          // Row for leading and action icons
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Leading icon (left side)
                if (showLeading)
                  Padding(
                    padding: EdgeInsets.only(top: 45.h, left: 10.w),
                    child: InkWell(
                      onTap: onLeadingPressed,
                      child: Image.asset(
                        leadingIcon,
                        fit: BoxFit.cover,
                        width: leadingWidth,
                        height: leadingHeight,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: leadingWidth ?? 40.w,
                  ), // To balance space if no icon
                // Actions (right side)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showAction1)
                      Padding(
                        padding: EdgeInsets.only(top: 35.h, right: 12.w),
                        child: IconButton(
                          icon: Icon(
                            actionIcon1,
                            color: Colors.white,
                            size: 26.w,
                          ),
                          onPressed: onAction1Pressed,
                        ),
                      ),
                    if (showAction2)
                      Padding(
                        padding: EdgeInsets.only(top: 35.h, right: 7.w),
                        child: InkWell(
                          onTap: onAction2Pressed,
                          child: Image.asset(actionIcon2, width: 22.w),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
