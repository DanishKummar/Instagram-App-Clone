import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';

class MarqueeWidget extends StatelessWidget {
  final String text;
  final double height;
  final TextStyle? style;

  const MarqueeWidget({
    super.key,
    required this.text,
    this.height = 20,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Marquee(
        text: text,
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 40.0,
        velocity: 30.0,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 5.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
        style:
            style ??
            TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              fontFamily: constants.primaryFont,
            ),
      ),
    );
  }
}
