import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';

class ImageTextbuttonWidget extends StatelessWidget {
  String text;
  String imageUrl;
  double width;
  double height;
  ImageTextbuttonWidget({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // container styling
      decoration: BoxDecoration(
        color: Color.fromARGB(211, 37, 41, 45),
        borderRadius: BorderRadius.circular(10.r),
      ),
      // button container
      child: SizedBox(
        // width: 100.w,
        height: 80.h,
        // image and text column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image sizebox
            SizedBox(
              height: height,
              width: width,
              // button image
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: 7.h),
            // card button text
            Text(
              text,
              // text styling
              style: TextStyle(
                fontFamily: constants.primaryFont,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
