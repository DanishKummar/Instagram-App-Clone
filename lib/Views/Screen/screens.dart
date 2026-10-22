import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:instagram_ui/controller/bottom_nav_controller.dart';
// import 'package:instagram_ui/controller/Firebase_Auth/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/BottomNavController/bottom_nav_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';

void main() {
  runApp(const Screens());
}

class Screens extends StatelessWidget {
  const Screens({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavController bottomNavController = Get.put(BottomNavController());

    return WillPopScope(
      onWillPop: () async {
        // If not on home tab, go to home instead of exiting
        if (bottomNavController.currentIndex.value != 0) {
          bottomNavController.changeTab(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(
          () => bottomNavController
              .screens[bottomNavController.currentIndex.value],
        ),
        bottomNavigationBar: Obx(
          () => SafeArea(
            child: Container(
              height: kBottomNavigationBarHeight + 10.h,
              decoration: BoxDecoration(
                color: Constants().navigationBgColor,
                border: Border(
                  top: BorderSide(
                    color: Constants().navigationBorderColor,
                    width: .5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: bottomNavController.currentIndex.value,
                onTap: bottomNavController.changeTab,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                items: [
                  bottomNavController.bottomNavigationBar(
                    bottomNavController,
                    "home",
                    0,
                  ),
                  bottomNavController.bottomNavigationBar(
                    bottomNavController,
                    "search",
                    1,
                  ),
                  bottomNavController.bottomNavigationBar(
                    bottomNavController,
                    "post",
                    2,
                  ),
                  bottomNavController.bottomNavigationBar(
                    bottomNavController,
                    "reels",
                    3,
                  ),
                  bottomNavController.bottomNavigationBar(
                    bottomNavController,
                    "dummy-dp",
                    4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
