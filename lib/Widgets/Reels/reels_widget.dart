import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/CustomScroller/custom_scroll_physics.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Controllers/Post_Controllers/PostShareController/share_controller.dart';
import 'package:new_insta/Controllers/Reels/Like/reel_like_controller.dart';
import 'package:new_insta/Customs/Appbar/custom_appbar.dart';
import 'package:new_insta/Models/Reels/reel_model.dart';
import 'package:new_insta/Widgets/Marquee/marquee_widget.dart';
import 'package:video_player/video_player.dart';

class ReelsWidget extends StatefulWidget {
  final List<ReelModel> reels;
  final ReelModel? reel;
  const ReelsWidget({super.key, required this.reels, this.reel});

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget> {
  int? __pausedIndex;
  int _currentIndex = 0;
  late PageController _pageController;
  final List<VideoPlayerController> _videoControllers = [];
  final StoryUploadController uploadController =
      Get.find<StoryUploadController>();
  final ShareController shareController = Get.put(ShareController());

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initializeVideos();
  }

  void _initializeVideos() {
    for (var reel in widget.reels) {
      final controller = VideoPlayerController.network(reel.videoUrl);
      controller.initialize().then((_) {
        setState(() {});
      });
      controller.setLooping(true);
      _videoControllers.add(controller);
    }

    if (_videoControllers.isNotEmpty) {
      _videoControllers[0].play();
    }
  }

  @override
  void dispose() {
    for (var c in _videoControllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i == index) {
        _videoControllers[i].play();
      } else {
        _videoControllers[i].pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.reels.length,
      physics: CustomScrollPhysics(),
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final reel = widget.reels[index];
        final reelLikeController = Get.put(ReelLikeController(reel.reelId));
        final videoController = _videoControllers[index];

        return GestureDetector(
          onLongPress: () {
            if (videoController.value.isInitialized &&
                videoController.value.isPlaying) {
              setState(() {
                __pausedIndex = index;
              });
              videoController.pause();
            }
          },
          onLongPressUp: () {
            if (videoController.value.isInitialized &&
                !_videoControllers[index].value.isPlaying) {
              videoController.play();
              setState(() {
                __pausedIndex = null;
              });
            }
          },

          child: Stack(
            fit: StackFit.expand,
            children: [
              // **** reel video with dynamic height like Instagram/TikTok ****
              videoController.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),

              // **** Overlay with user info, music, icons, etc. ****
              Positioned(
                bottom: 20,
                left: 15,
                right: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // **** username ****
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                width: 30.r,
                                height: 30.r,
                                padding: EdgeInsets.all(1.sp),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        uploadController.userData['photoUrl'] ??
                                        '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                uploadController.userData['username'] ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: constants.primaryFont,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),

                          // **** reel caption ****
                          Text(
                            reel.caption,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: constants.primaryFont,
                              fontSize: 14.sp,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 5.h),

                          // **** music icon + music artist + music title ****
                          if (reel.musicTitle != null)
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  width: 18.r,
                                  height: 18.r,
                                  padding: EdgeInsets.all(1.sp),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: CachedNetworkImage(
                                      imageUrl: reel.musicCoverimage ?? '',
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('assets/icons/music.png'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: MarqueeWidget(
                                    text:
                                        '${reel.musicTitle} - ${reel.musicArtist ?? ""}',
                                  ),
                                ),
                                SizedBox(width: 60.w, height: 20.h),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // **** like + comment + share icons ****
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: reelLikeController.toggleLike,
                              child: Obx(
                                () => Icon(
                                  reelLikeController.isLiked.value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 25.sp,
                                  color: reelLikeController.isLiked.value
                                      ? Colors.red
                                      : Colors.white,
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                reelLikeController.likeCount.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Like Button + Count
                        SizedBox(height: 20.h),
                        // ****** comment icon ********
                        InkWell(
                          onTap: () {},
                          child: FaIcon(
                            FontAwesomeIcons.comment,
                            size: 25.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        // ****** comment count ********
                        Text(
                          reel.commentCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        InkWell(
                          onTap: () {
                            print(
                              'There are ${reel.commentCount} in this reel',
                            );
                          },
                          // ************ share icon ***********
                          child: InkWell(
                            onTap: () {
                              shareController.shareContent(
                                id: reel.reelId,
                                caption: reel.caption,
                                mediaUrl: reel.videoUrl,
                                isReel: true,
                              );
                            },
                            child: FaIcon(
                              FontAwesomeIcons.paperPlane,
                              size: 25.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 120.h),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
