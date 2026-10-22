import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Controllers/CreateStoryController/create_story.dart';

class AudioPlayerContainerWidget extends StatelessWidget {
  final AudioController audioController = Get.put(AudioController());
  // Getting the instance of the AudioController using GetX
  AudioPlayerContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final music = audioController.currentMusic.value;
      if (music == null) return SizedBox(); // Hide if nothing selected
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 25.h),
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          // box color
          color: Color(0xFF591410),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Album art / music cover image
            Container(
              padding: EdgeInsets.all(.4.sp),
              margin: EdgeInsets.only(left: 13.w, right: 10.w),
              width: 35.w,
              height: 35.h,
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
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            ),

            Expanded(
              child:
                  // Title and artist text column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          color: const Color.fromARGB(210, 230, 230, 230),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
            ),
            // ****** toggle pause and play gesture icon
            GestureDetector(
              onTap: () {
                audioController.togglePlayPause(music.musicUrl);
              },
              child:
                  // if current music url equals to tapped url
                  audioController.tappedUrl.value ==
                      audioController.currentUrl.value
                  ?
                    // if audio is playing
                    audioController.isPlaying.value
                        ?
                          // show pause icon
                          Icon(
                            Icons.pause_circle_filled,
                            color: Color.fromARGB(255, 140, 172, 194),
                            size: 33.sp,
                          )
                        :
                          // else show play icon
                          Lottie.asset(
                            "assets/lottie-images/play.json",
                            width: 40.w,
                            height: 40.h,
                          )
                  // if tapped url does not equal to current url
                  :
                    // show pause icon
                    Lottie.asset(
                      "assets/lottie-images/play.json",
                      width: 40.w,
                      height: 40.h,
                    ),
            ),
            // right arrow icon container
            GestureDetector(
              onTap: () {
                // for play audio in loop
                audioController.selectedMusicPlayLoop(music);
                audioController.selectMusic(music);
                // for go to created music caption story view
                Get.to(() => CreateMusicCaptionStoryView());
              },
              child: Container(
                width: 26.w,
                height: 26.h,
                padding: EdgeInsets.all(4.sp),
                margin: EdgeInsets.only(right: 15.w, left: 4.w),
                // box decoration
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                // arrow icon
                child: Image.asset("assets/icons/right-arrow.png"),
              ),
            ),
          ],
        ),
      );
    });
  }
}
