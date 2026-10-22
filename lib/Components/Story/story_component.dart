import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/MyStoryController/my_story_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/FetchStoryController/fetch_story_controller.dart';
import 'package:new_insta/Models/StoryModel/story_model.dart';
import 'package:new_insta/Views/SeeStoryView/see_story_view.dart';

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  StoryWidget({Key? key, required this.story}) : super(key: key);

  final MyStoryController controller = Get.put(MyStoryController());
  final AudioController audioController = Get.put(AudioController());
  final StoryFetchController fetchController = Get.put(StoryFetchController());

  @override
  Widget build(BuildContext context) {
    final isStoryTypeValid =
        story.storyType != null && story.storyType!.trim().isNotEmpty;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => SeeStoryView(
            imageUrl: story.imageUrl,
            musicUrl: story.musicUrl,
            username: story.username,
            storyType: story.storyType?.trim(),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 93.w,
            height: 93.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF833AB4),
                  Color(0xFFF77737),
                  Color(0xFFE1306C),
                  Color(0xFFC13584),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              padding: EdgeInsets.all(2.5.w),
              child: ClipOval(
                child: Image.network(
                  isStoryTypeValid ? story.storyType! : story.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: 85.w,
            child: Text(
              story.username,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                fontFamily: constants.primaryFont,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
