import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppbarController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxBool isAppbarVisible = true.obs;
  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // scrolling down
        isAppbarVisible.value = false;
        print(isAppbarVisible.value);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // scrolling up
        isAppbarVisible.value = true;
        print(isAppbarVisible.value);
      }
    });
    super.onInit();
  }
}
