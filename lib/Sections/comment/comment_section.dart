import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/Comment/comment_component.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/Post_FetchController/post_fetch_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/commentController/comment_controller.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';
import 'package:new_insta/Models/Post/commentModel/comment_model.dart';
import 'package:new_insta/Widgets/TextWidget/text_widget.dart';

final RxString commentText = ''.obs;

void showCommentBottomSheetCommentSection(BuildContext context, String postId) {
  final commentController = Get.put(CommentController());
  final postFetchController = Get.put(PostFetchController());
  final authController = Get.put(FirebaseAuthController());
  final commentTextController = TextEditingController();
  final StoryUploadController uploadController =
      Get.find<StoryUploadController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .95,
        minChildSize: 0.3,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF222328),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Top bar
                Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                // Comments List
                Expanded(
                  child: StreamBuilder<List<CommentModel>>(
                    stream: commentController.streamComments(postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No comments yet",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final comments = snapshot.data!;
                      final PostModel? matchedPost = postFetchController.posts
                          .firstWhereOrNull((post) => post.postId == postId);

                      if (matchedPost == null) {
                        return const Center(
                          child: Text(
                            "Post not found.",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return CommentComponent(
                            post: matchedPost,
                            comment: comments[index],
                          );
                        },
                      );
                    },
                  ),
                ),

                // Comment input field
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 5.h,
                    left: 10.w,
                    right: 10.w,
                  ),
                  child: FieldWidget(
                    controller: commentTextController,
                    hintText: 'Add a comment...',
                    obscureText: false,
                    inputType: TextInputType.text,
                    fillColor: Colors.transparent,
                    borderRadius: 10,
                    outlineColor: const Color.fromARGB(72, 110, 110, 110),
                    textStyle: TextStyle(
                      fontFamily: constants.primaryFont,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (val) => commentText.value = val,
                    suffixIcon: Obx(
                      () => commentText.value.trim().isNotEmpty
                          ? GestureDetector(
                              onTap: () async {
                                final comment = commentText.value.trim();
                                if (comment.isEmpty) return;

                                final currentUser = authController.currentUser;
                                if (currentUser == null) {
                                  Get.snackbar("Error", "User not logged in");
                                  return;
                                }

                                // Ensure userData is loaded
                                if (uploadController.userData.isEmpty) {
                                  await uploadController
                                      .fetchUserData(); // fallback
                                  if (uploadController.userData.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "User info not loaded",
                                    );
                                    return;
                                  }
                                }

                                final username =
                                    uploadController.userData['username'] ??
                                    'User';
                                final photoUrl =
                                    uploadController.userData['photoUrl'] ?? '';

                                try {
                                  final commentRef = FirebaseFirestore.instance
                                      .collection('user_post')
                                      .doc(postId)
                                      .collection('comment')
                                      .doc();

                                  final commentModel = CommentModel(
                                    commentId: commentRef.id,
                                    userId: currentUser.uid,
                                    userImage: photoUrl,
                                    text: comment,
                                    createdAt: DateTime.now(),
                                    likedBy: [],
                                    likeCount: 0,
                                    username: username,
                                  );

                                  await commentRef.set(commentModel.toJson());

                                  commentTextController.clear();
                                  commentText.value = '';
                                  FocusScope.of(context).unfocus();

                                  // print(
                                  //   "✅***************************** Comment posted by $username",
                                  // );
                                  // print(
                                  //   "✅***************************** Comment posted by $photoUrl",
                                  // );
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to post comment: $e",
                                  );
                                }
                              },
                              child: Icon(
                                Icons.send,
                                size: 22.sp,
                                color: Colors.blue,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
