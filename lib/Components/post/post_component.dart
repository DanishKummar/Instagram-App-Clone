import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/Comment/comment_component.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FollowController/follow_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/LikePostController/like_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/PostShareController/share_controller.dart';
import 'package:new_insta/Customs/BottomSheet/custom_bottom_sheet.dart';
import 'package:new_insta/Models/Post/PostMediaItems/media_items.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';
import 'package:new_insta/Sections/comment/comment_section.dart';
import 'package:new_insta/Widgets/Marquee/marquee_widget.dart';
import 'package:new_insta/Widgets/MediaSliderWidget/media_slider_widget.dart';

class PostComponent extends StatelessWidget {
  final PostModel post;
  const PostComponent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final FollowController followController = Get.put(FollowController());
    final LikeController likeController = Get.put(LikeController());
    final ShareController shareController = Get.put(ShareController());
    // Load likes once when widget is built
    likeController.loadLikes(post.postId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile image
              Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.all(.5.sp),
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 150, 150, 150),
                ),
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(
                      post.userImage,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.person, size: 40.r),
                    ),
                  ),
                ),
              ),

              // Username and music info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: constants.primaryFont,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // music (artist & title) row
                    Row(
                      children: [
                        Expanded(
                          //  music (artist & title) marquee
                          child: MarqueeWidget(
                            text: '${post.musicArtist} - ${post.musicTitle}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Follow/unfollow button with reactive state
              Obx(() {
                final isFollowing = followController.isFollowing(post.userUid);
                return Container(
                  padding: EdgeInsets.only(left: 80.w),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    // follow/following button
                    child: ElevatedButton(
                      onPressed: () {
                        // toggle follow/unfollow user
                        followController.toggleFollow(post.userUid);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // button text
                      child: Text(
                        isFollowing ? "Folllowing" : "Follow",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: constants.primaryFont,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // carousel (image & video)
        MediaSliderWidget(
          mediaUrls: post.mediaItems.map((item) => item.url).toList(),
          mediaTypes: post.mediaItems.map((item) => item.type).toList(),
          post: post,
        ),

        // Like + Comment Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final isLiked = likeController.hasLiked(post.postId);
                final count = likeController.likeCountMap[post.postId] ?? 0;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => likeController.toggleLike(post.postId),
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        children: [
                          // like icon
                          FaIcon(
                            isLiked
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: isLiked ? Colors.red : Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          // like text
                          Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16.w),
                    // ========= post Comments ============
                    InkWell(
                      onTap: () {
                        // open comment screen
                        showCommentBottomSheetCommentSection(
                          context,
                          post.postId,
                        );
                      },
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.comment, size: 20.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${post.commentCount}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              // ========= post Share Button ============
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // optional for visual touch ripple
                    onTap: () {
                      final firstImageItem = post.mediaItems.firstWhere(
                        (item) => item.type == 'image',
                        orElse: () => MediaItem(type: '', url: ''),
                      );
                      final imageUrl = firstImageItem.url;

                      shareController.shareContent(
                        id: post.postId,
                        caption: post.caption,
                        mediaUrl: imageUrl,
                        isReel: false,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                        8.0,
                      ), // increases touch target area
                      child: FaIcon(FontAwesomeIcons.paperPlane, size: 20.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ========= post Caption ============
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            post.caption,
            style: TextStyle(
              fontFamily: constants.primaryFont,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
