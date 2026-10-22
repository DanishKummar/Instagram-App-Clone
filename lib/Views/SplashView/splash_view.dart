import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:new_insta/Controllers/FollowController/follow_controller.dart';
import 'package:new_insta/Views/AuthViews/Login/login_view.dart';
import 'package:new_insta/Views/FollowUserView/follow_user_view.dart';
import 'package:new_insta/Views/Screen/screens.dart';

FollowController followController = Get.put(FollowController());

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    navigateBasedOnUserStatus();
    print(followController.canAccessFeed());
  }

  // Function to handle navigation logic
  void navigateBasedOnUserStatus() {
    // Delay 3 seconds and then navigate to login or home screen
    Timer(Duration(seconds: 2), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // wait for folloe coutnt to load
        // await followController.fetchFollowingCount();

        // if (followController.canAccessFeed()) {
        Get.off(() => Screens());
        // } else {
        //   Get.off(() => UsersListView());
        // }
      } else {
        // Get.off(() => LogInView());
        Get.to(() => LogInView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // App logo
          Center(
            child: Image.asset(
              "assets/images/insta-icon.webp",
              width: 250.w,
              height: 120.h,
            ),
          ),
          // Meta logo
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "assets/images/meta.png",
                width: 70.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
