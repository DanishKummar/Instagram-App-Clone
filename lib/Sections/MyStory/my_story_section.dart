import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirestoreController/FetchStoryController/fetch_story_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/MyStoryController/my_story_controller.dart';
import 'package:new_insta/Controllers/StoryNavController/story_nav_controller.dart';
import 'package:new_insta/Views/SeeStoryView/see_story_view.dart';

class MyStory extends StatelessWidget {
  final VoidCallback onpress;

  MyStory({super.key, required this.onpress});

  final MyStoryController controller = Get.put(MyStoryController());
  final StoryFetchController storyFetchController = Get.put(
    StoryFetchController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasStory = controller.hasStory.value;
      final imageUrl = controller.storyImageUrl?.value ?? '';
      final musicUrl = controller.storyMusicUrl?.value ?? '';

      return Padding(
        padding: EdgeInsets.only(left: 15.w, right: 5.w),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async {
                    await storyFetchController.mystory(); // Refresh storyType
                    final updatedType = storyFetchController.storyType.value
                        .trim();

                    final imageUrl = controller.storyImageUrl?.value ?? '';
                    final musicUrl = controller.storyMusicUrl?.value ?? '';

                    if (updatedType.isNotEmpty || imageUrl.isNotEmpty) {
                      String username = '';
                      try {
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .get();
                        if (userDoc.exists &&
                            userDoc.data()!.containsKey('username')) {
                          username = userDoc['username'];
                        }
                      } catch (e) {
                        print("❌ Error getting username: $e");
                      }

                      print('✅ Navigating with imageUrl: $imageUrl');
                      print('✅ Navigating with musicUrl: $musicUrl');
                      print('✅ Navigating with storyType: $updatedType');

                      Get.to(
                        () => SeeStoryView(
                          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                          musicUrl: musicUrl.isNotEmpty ? musicUrl : null,
                          username: username,
                          storyType: updatedType.isNotEmpty
                              ? updatedType
                              : null,
                        ),
                      );
                    } else {
                      onpress(); // Go to create/upload story
                    }
                  },

                  child: Container(
                    width: 93.w,
                    height: 93.h,
                    padding: hasStory ? EdgeInsets.all(2.5.w) : null,
                    decoration: hasStory
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF833AB4),
                                Color(0xFFF77737),
                                Color(0xFFE1306C),
                                Color(0xFFC13584),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          )
                        : null,
                    child: ClipOval(
                      child: _buildStoryImage(hasStory, imageUrl),
                    ),
                  ),
                ),
                if (!hasStory)
                  Positioned(
                    bottom: 0,
                    right: -5,
                    child: Container(
                      height: 28.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.black),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.black, size: 18.sp),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              "Your story",
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Dynamically build story image preview based on storyType
  Widget _buildStoryImage(bool hasStory, String imageUrl) {
    final storyType = storyFetchController.storyType;

    if (!hasStory) {
      return Image.asset("assets/images/my_story.png", fit: BoxFit.cover);
    }

    if (storyType.isNotEmpty && storyType.startsWith('http')) {
      return Image.network(
        storyType.toString(),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }

    if (storyType.toLowerCase().contains("file:")) {
      final path = storyType.split("File: ").last.replaceAll("'", "").trim();
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }
}
