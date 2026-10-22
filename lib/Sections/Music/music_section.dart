import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Models/Music/music_model.dart';

// ignore: must_be_immutable
class MusicWidget extends StatelessWidget {
  final MusicModel music;

  // Getting the instance of the AudioController using GetX
  final AudioController audioController = Get.find();

  MusicWidget({Key? key, required this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obx is used to reactively rebuild the widget when tappedUrl changes
    return Obx(() {
      // Check if the currently tapped song matches this music item
      final isTapped = audioController.tappedUrl.value == music.musicUrl;

      return GestureDetector(
        // When the item is tapped, toggle play/pause of the corresponding audio
        onTap: () {
          // toggle play and pause
          audioController.togglePlayPause(music.musicUrl);
          // selected msic
          audioController.selectMusic(music);
          FocusScope.of(context).unfocus();
        },
        // AnimatedContainer gives visual feedback with animation on tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          // Highlight the background if this item is tapped
          decoration: BoxDecoration(
            color: isTapped
                // Highlight color
                ? const Color(0xFF2b3036)
                // Default background
                : Colors.transparent,
            // borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Album art / music cover image
              Container(
                padding: EdgeInsets.all(.5.sp),
                width: 43.w,
                height: 41.h,
                // box decoration
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: const Color.fromARGB(210, 155, 155, 155),
                ),
                clipBehavior: Clip.hardEdge,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  // artist cover image
                  child: CachedNetworkImage(
                    imageUrl: music.coverImage.toString(),
                    fit: BoxFit.cover,
                    width: 43.w,
                    height: 41.h,
                    // Placeholder while image loads
                    placeholder: (context, url) => Center(
                      child: SizedBox(width: 20.w, height: 20.h),
                    ),
                    // Error widget if image fails to load
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, size: 24.sp),
                  ),
                ),
              ),
              // Space between image and text
              SizedBox(width: 10.w),
              // Title and artist text column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // show lottie play audio animaton if audio is plaing
                    isTapped
                        ? Row(
                            children: [
                              // if current music url equals to tapped url
                              isTapped
                                  // if audio is playing
                                  ? audioController.isPlaying.value
                                        ?
                                          //  show lottie play animation
                                          Lottie.asset(
                                            "assets/lottie-images/play-audio-frequency.json",
                                            height: 15.h,
                                            width: 15.w,
                                          )
                                        // if audio is paused show paused icon
                                        : Image.asset(
                                            "assets/icons/pause-icon-lottie.png",
                                            width: 15.w,
                                            height: 12.h,
                                          )
                                  // at beginning show nothing
                                  : SizedBox(),
                              SizedBox(width: 5.w),
                              // show artist name
                              Text(
                                music.title,
                                style: TextStyle(
                                  color: Color(0xFFb8d9ef),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5.sp,
                                  letterSpacing: -.59.sp,
                                ),
                              ),
                            ],
                          )
                        :
                          // Music title
                          Text(
                            music.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5.sp,
                              letterSpacing: -.59.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    // Music artist name
                    Text(
                      music.artist,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color.fromARGB(210, 190, 190, 190),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
