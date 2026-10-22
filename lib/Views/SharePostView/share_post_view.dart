import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/post/post_component.dart';
import 'package:new_insta/Controllers/Post_Controllers/Post_FetchController/post_fetch_controller.dart';
import 'package:new_insta/Controllers/Reels/reel_controller.dart';
import 'package:new_insta/Customs/Appbar/custom_appbar.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';

class SharePostView extends StatelessWidget {
  final String? postId;

  const SharePostView({super.key, this.postId});

  @override
  Widget build(BuildContext context) {
    final PostFetchController postFetchController = Get.put(
      PostFetchController(),
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // ******** appbar **********
            CustomAppbar(
              // appbar leading
              showLeading: true,
              leadingIcon: 'assets/icons/go_back.png',
              leadingWidth: 25.w,
              leadingHeight: 25.h,
              // leading action
              onLeadingPressed: () {
                Get.back();
              },
              // appbar title image
              showTitle: true,
              title: Center(
                child: Image.asset('assets/images/insta-black-mode-logo.png'),
              ),
            ),
            FutureBuilder<PostModel?>(
              future: postFetchController.fetchPostById(postId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("Post not found"));
                }

                final post = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      PostComponent(post: post), // Your full post UI
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
