import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/BottomNavController/bottom_nav_controller.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Sections/Reel/reel_section.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});
  @override
  Widget build(BuildContext context) {
    final BottomNavController navController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () => navController.changeTab(0),
          child: Icon(Icons.arrow_back, size: 30.sp),
        ),
        title: Text(
          'Reels',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: constants.primaryFont,
          ),
        ),
      ),
      body: SafeArea(child: ReelsSection()),
    );
  }
}
