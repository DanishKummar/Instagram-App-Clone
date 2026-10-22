import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirestoreController/StoryController/story_controller.dart';
import 'package:new_insta/Components/Story/story_component.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final StoryController storyController = Get.put(StoryController());

    return SizedBox(
      height: 120.h,
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        final followedStories = storyController.followedStories;

        if (followedStories.isEmpty) return SizedBox();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: followedStories.length,
          itemBuilder: (context, index) {
            final story = followedStories[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 7.w),
              child: StoryWidget(story: story),
            );
          },
        );
      }),
    );
  }
}
