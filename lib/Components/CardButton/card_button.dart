import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';

class RoundedCardButton extends StatelessWidget {
  var img;
  var text;
  RoundedCardButton({super.key, this.img, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(211, 37, 41, 45),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, width: 20.w),
          SizedBox(width: 8.w), // spacing between icon and text
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontFamily: constants.primaryFont,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
