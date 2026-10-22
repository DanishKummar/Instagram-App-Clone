// ********************* This Home Screen ********************
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/AppBarController/appbar_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/StoryController/story_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UserController/user_controller.dart';
import 'package:new_insta/Customs/Appbar/custom_appbar.dart';
import 'package:new_insta/Sections/MyStory/my_story_section.dart';
import 'package:new_insta/Sections/Post/post_section.dart';
import 'package:new_insta/Sections/Story/story_section.dart';
import 'package:new_insta/Views/FollowUserView/follow_user_view.dart';
import 'package:new_insta/Views/UploadStoryView/upload_story_view.dart';

void main() {
  runApp(const HomeView());
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize necessary controllers
    AppbarController appbarController = Get.put(AppbarController());
    UserController userController = Get.put(UserController());
    StoryController storyController = Get.put(StoryController());

    // Call this to clean up stories older than 24 hours
    storyController.deleteExpiredStories();

    return Scaffold(
      // ********** AppBar Section ***********
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Obx(
          () => AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: appbarController.isAppbarVisible.value
                ? CustomAppbar(
                    showLeading: true,
                    leadingIcon: "assets/images/insta-black-mode-logo.png",
                    onAction1Pressed: () {
                      // Navigate to following/followers page
                      Get.to(UsersListView());
                    },
                    showAction1: true,
                    actionIcon1: Icons.favorite_border,
                    showAction2: true,
                    actionIcon2: "assets/icons/messanger-dark-mode.png.png",
                    onAction2Pressed: () {
                      // Example usage: add user or handle custom action
                      userController.addUser();
                    },
                  )
                : SizedBox.shrink(),
          ),
        ),
      ),

      // ********** Main Body Section ***********
      body: SingleChildScrollView(
        controller: appbarController.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // ********** Story Section ***********
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // User's own story widget
                  MyStory(
                    onpress: () {
                      Get.to(() => UploadStoryScreen());
                    },
                  ),

                  // Other users' stories
                  StorySection(),
                ],
              ),
            ),

            // Vertical spacing
            SizedBox(height: 20),

            PostSection(),
          ],
        ),
      ),
    );
  }
}
