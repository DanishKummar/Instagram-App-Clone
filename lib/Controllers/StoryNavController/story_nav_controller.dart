import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/StoryModel/story_model.dart';

class StoryNavController extends GetxController {
  // current index
  var currentIndex = 0.obs;
  late PageController pageController;
  // pass story list
  final List<StoryModel> stories;
  StoryNavController({required this.stories}) {
    // page controller based on the initial index
    pageController = PageController(initialPage: currentIndex.value);
  }

  // function for go next story
  void goToNext() {
    if (currentIndex.value < stories.length - 1) {
      currentIndex.value++;
      // next page controller animation
      pageController.animateToPage(
        currentIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // go to back
      Get.back();
    }
  }

  // go to previous story
  void goToPrevious() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      pageController.animateToPage(
        currentIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
