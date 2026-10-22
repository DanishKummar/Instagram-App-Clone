import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/LikePostController/like_controller.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';
import 'package:new_insta/Models/Post/commentModel/comment_model.dart';
import 'package:new_insta/Widgets/TextField/textfield_widget.dart';

class CommentComponent extends StatelessWidget {
  final CommentModel comment;
  final PostModel post;

  const CommentComponent({
    super.key,
    required this.comment,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final LikeController likeController = Get.put(LikeController());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Image
          Container(
            padding: EdgeInsets.all(1.sp),
            width: 45.w,
            height: 45.w,
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(139, 123, 123, 123),
            ),
            child: ClipOval(
              child: comment.userImage.isNotEmpty
                  ? Image.network(
                      comment.userImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default_user.png',
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 1),
                        );
                      },
                    )
                  : Icon(Icons.person, size: 40.r),
            ),
          ),

          // Username and comment
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // username
                Text(
                  comment.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    fontFamily: constants.primaryFont,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                // comment text
                Text(
                  comment.text,
                  style: TextStyle(
                    fontSize: 13.4.sp,
                    fontFamily: constants.primaryFont,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // Like icon
          Obx(() {
            final isLiked = likeController.hasLikedComment(comment.commentId);
            return GestureDetector(
              onTap: () => likeController.toggleCommentLike(
                post.postId,
                comment.commentId,
              ),
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 10.w),
                child: FaIcon(
                  isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: isLiked ? Colors.red : Colors.white,
                  size: 18.sp,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
