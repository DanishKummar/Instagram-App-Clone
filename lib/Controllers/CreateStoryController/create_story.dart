import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/CardButton/card_button.dart';
import 'package:new_insta/Components/Option/option.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Controllers/RotatingController/rotating_controller.dart';
import 'package:new_insta/Customs/BottomSheet/custom_bottom_sheet.dart';
import 'package:new_insta/Customs/Dialog/custom_dialog.dart';
import 'package:new_insta/Widgets/ElevatedButton/elevatedbutton_widget.dart';

class CreateMusicCaptionStoryView extends StatefulWidget {
  CreateMusicCaptionStoryView({super.key});

  @override
  State<CreateMusicCaptionStoryView> createState() =>
      _CreateMusicCaptionStoryViewState();
}

class _CreateMusicCaptionStoryViewState
    extends State<CreateMusicCaptionStoryView> {
  // audio controller
  final AudioController audioController = Get.put(AudioController());

  // rotating controller
  final RotatingController rotatingController = Get.put(RotatingController());

  // StoryUploadController
  final StoryUploadController storyUploadController = Get.put(
    StoryUploadController(),
  );

  @override
  void initState() {
    super.initState();
    rotatingController.start();
  }

  @override
  void dispose() {
    rotatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        final music = audioController.currentMusic.value;
        if (music == null) {
          return const Center(child: CircularProgressIndicator());
          // return SizedBox();
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SizedBox(
                height: 0.8.sh,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    CachedNetworkImage(
                      imageUrl: music.coverImage.toString(),
                      fit: BoxFit.cover,
                    ),

                    // Blur effect with BackdropFilter + subtle black tint
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.08),
                            spreadRadius: 25,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(color: Colors.black.withOpacity(0.2)),
                      ),
                    ),

                    // Gradient overlay from transparent to black bottom
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                    // go back icon top of the screen
                    Positioned(
                      top: 0,
                      // gesture on icon container
                      child: GestureDetector(
                        // icon ontap functionality
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 50), () {
                            showCustomDialog(
                              title: "Discard edits?",
                              message:
                                  "If you go back now, you'll lose all the edits you've made.",
                              confirmText: "Discard",
                              cancelText: "Keep Editing",
                              onConfirm: () {
                                Get.back(); // dialog
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Get.back(); // screen
                                });
                              },
                            );
                          });
                        },
                        // icon container
                        child: Container(
                          margin: EdgeInsets.only(top: 20.h, left: 20.w),
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(185, 0, 0, 0),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          // left arrow
                          child: Center(child: Icon(Icons.arrow_back_ios_new)),
                        ),
                      ),
                    ),
                    // music title, artist and cover image --> column
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // rotating cover image on the disc
                        RotationTransition(
                          turns: rotatingController.rotationController,
                          child: Stack(
                            alignment: Alignment.center,
                            // disc for cover image
                            children: [
                              Image.asset(
                                "assets/images/disc.png",
                                width: 200.w,
                              ),
                              // cover image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: CachedNetworkImage(
                                  imageUrl: music.coverImage.toString(),
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // gap
                        SizedBox(height: 10.h),
                        // music title
                        Text(
                          music.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: constants.primaryFont,
                            fontSize: 18.sp,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        // gap
                        SizedBox(height: 3.h),
                        // music artist
                        Text(
                          music.artist,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: constants.primaryFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // bottom buttons
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                // bottom buttons row
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    // your story button card
                    Expanded(
                      child: RoundedCardButton(
                        img: "assets/images/my_story.png",
                        text: "Your story",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    // close button card
                    Expanded(
                      child: RoundedCardButton(
                        img: "assets/icons/star.png",
                        text: "Close Friends",
                      ),
                    ),
                    // go forward button
                    GestureDetector(
                      onTap: () {
                        // ************ share botom sheet ***************
                        CustomBottomSheet.show(
                          child: SizedBox(
                            height: 0.5.sh, // Limit height to avoid overflow
                            child: Column(
                              children: [
                                // Title
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Share",
                                    style: TextStyle(
                                      fontFamily: constants.primaryFont,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                                // option list tile
                                OptionWidget(),
                                SizedBox(
                                  height: 45.h,
                                  child: ElevatedbuttonWidget(
                                    buttonText: "Share",
                                    callback: () async {
                                      // **** stop audio ****
                                      audioController.resetAudio();
                                      // **** send story image and music to firebase ****
                                      await storyUploadController
                                          .uploadSelectedAdminMusicFromUrl(
                                            imageUrl: music.coverImage
                                                .toString(),
                                            musicUrl: music.musicUrl,
                                          );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5.w, right: 10.w),
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        // left arrow
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
