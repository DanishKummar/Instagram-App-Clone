import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';
import 'package:video_player/video_player.dart';

import '../../Controllers/MediaSliderController/media_slider_controller.dart';

class MediaSliderWidget extends StatefulWidget {
  final List<String> mediaUrls;
  final List<String> mediaTypes;
  final PostModel post;

  const MediaSliderWidget({
    super.key,
    required this.mediaUrls,
    required this.mediaTypes,
    required this.post,
  });

  @override
  State<MediaSliderWidget> createState() => _MediaSliderWidgetState();
}

class _MediaSliderWidgetState extends State<MediaSliderWidget> {
  late final String _tag;
  late final MediaSliderController ctrl;

  @override
  void initState() {
    super.initState();
    _tag = UniqueKey().toString();
    ctrl = Get.put(MediaSliderController(), tag: _tag);
    ctrl.initialize(widget.mediaUrls, widget.mediaTypes);
  }

  @override
  void dispose() {
    Get.delete<MediaSliderController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.width * 6 / 4;
    final AudioController audioController = Get.put(AudioController());
    return Column(
      children: [
        SizedBox(
          height: mediaHeight,
          width: double.infinity,
          child: PageView.builder(
            controller: ctrl.pageController,
            itemCount: widget.mediaUrls.length,
            onPageChanged: ctrl.onPageChanged,
            itemBuilder: (context, index) {
              final url = widget.mediaUrls[index];
              final type = widget.mediaTypes[index];
              // image
              return Stack(
                fit: StackFit.expand,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: type == 'image'
                        ? CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                const Center(child: SizedBox()),
                            errorWidget: (_, __, ___) =>
                                const Center(child: Icon(Icons.error)),
                          )
                        // video
                        : Obx(() {
                            final videoCtrl = ctrl.videoController[index];
                            if (videoCtrl != null &&
                                videoCtrl.value.isInitialized) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [VideoPlayer(videoCtrl)],
                              );
                            }
                            // circular bar indicator
                            else {
                              return const Center(child: SizedBox());
                            }
                          }),
                  ),
                  // items count (image and video)
                  Positioned(
                    right: 15,
                    top: 15,
                    child: Obx(() {
                      final currentIndex = ctrl.currentIndex.value;
                      return Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(192, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${currentIndex + 1}/${widget.mediaUrls.length}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: constants.primaryFont,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  // Music play/pause button
                  Positioned(
                    bottom: 25,
                    right: 15,
                    child: Obx(() {
                      final isCurrent = ctrl.currentIndex.value == index;
                      final isActiveMusic =
                          audioController.currentUrl.value ==
                          widget.post.musicUrl;
                      final isPlaying = audioController.isPlaying.value;

                      if (!isCurrent) return const SizedBox();

                      return InkWell(
                        onTap: () {
                          audioController.togglePlayPause(
                            widget.post.musicUrl.toString(),
                          );
                        },
                        child: Icon(
                          isActiveMusic && isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: const Color.fromARGB(113, 255, 255, 255),
                          size: 40.sp,
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
        // Indicator Dots
        Obx(() {
          final currentIndex = ctrl.currentIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.mediaUrls.length, (index) {
              final isActive = index == currentIndex;
              return Container(
                width: 5.w,
                height: 5.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
