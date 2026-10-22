import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/Reels/reel_controller.dart';
import 'package:new_insta/Widgets/Reels/reels_widget.dart';

class ReelsSection extends StatelessWidget {
  final ReelController reelController = Get.put(ReelController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reelController.reels.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ReelsWidget(reels: reelController.reels);
    });
  }
}
