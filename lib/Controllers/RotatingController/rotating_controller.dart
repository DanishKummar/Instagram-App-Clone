import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotatingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController rotationController;

  @override
  void onInit() {
    super.onInit();
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  /// Start rotation
  void start() {
    rotationController.repeat();
  }

  /// Stop rotation
  void stop() {
    rotationController.stop();
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}
