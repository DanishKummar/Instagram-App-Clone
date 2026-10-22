import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/post/post_component.dart';
import 'package:new_insta/Controllers/Post_Controllers/Post_FetchController/post_fetch_controller.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});
  @override
  Widget build(BuildContext context) {
    // post fetch controller
    final PostFetchController postFetchController = Get.put(
      PostFetchController(),
    );
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: postFetchController.posts.length,
        itemBuilder: (context, index) {
          final post = postFetchController.posts[index];
          return PostComponent(post: post);
        },
      );
    });
  }
}
