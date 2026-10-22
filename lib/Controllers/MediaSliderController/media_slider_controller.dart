import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MediaSliderController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxMap<int, VideoPlayerController?> videoController =
      <int, VideoPlayerController?>{}.obs;

  List<String> mediaUrls = [];
  List<String> mediaTypes = [];

  void initialize(List<String> urls, List<String> types) {
    mediaUrls = urls;
    mediaTypes = types;

    for (int i = 0; i < mediaUrls.length; i++) {
      if (mediaTypes[i] == 'video') {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(mediaUrls[i]),
        );
        controller.initialize().then((_) {
          videoController[i] = controller;
          update(); // optional
        });
      }
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    for (final entry in videoController.entries) {
      entry.value?.pause();
    }
    final controller = videoController[index];
    if (controller != null && controller.value.isInitialized) {
      controller.play();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    for (final controller in videoController.values) {
      controller?.dispose();
    }
    super.onClose();
  }
}
