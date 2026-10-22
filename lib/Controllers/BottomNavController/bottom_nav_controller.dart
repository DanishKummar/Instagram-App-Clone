import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Home/home_view.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Post/post_view.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Profile/profile_view.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Reels/reels_view.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Search/search_view.dart';
// import 'package:instagram_ui/view/home_view.dart';
// import 'package:instagram_ui/view/post_view.dart';
// import 'package:instagram_ui/view/profile_view.dart';
// import 'package:instagram_ui/view/reels_view.dart';
// import 'package:instagram_ui/view/search_view.dart';

class BottomNavController extends GetxController {
  // creating a observable index
  var currentIndex = 0.obs;
  // List of screens for navigation
  final List<Widget> screens = [
    HomeView(),
    SearchView(),
    PostView(),
    ReelsView(),
    ProfileView(),
  ];
  // change screens on tab
  void changeTab(int index) {
    // change current index
    currentIndex.value = index;
  }

  // bottom navigation custom
  BottomNavigationBarItem bottomNavigationBar(
    BottomNavController controller,
    String iconName,
    int index,
  ) {
    bool isSelected = controller.currentIndex.value == index;
    return BottomNavigationBarItem(
      icon: Image.asset(
        "assets/icons/${iconName}-dark-mode${isSelected ? '-filled' : ''}.png",
        width: 26,
        height: 26,
      ),
      label: '',
    );
  }
}
