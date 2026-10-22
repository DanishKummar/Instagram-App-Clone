import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_insta/Components/AudioPlayerContainer/audio_player_container.dart';
import 'package:new_insta/Controllers/AudioController/audio_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UserMusicController/user_music_controller.dart';
import 'package:new_insta/Sections/Music/music_section.dart';
import 'package:new_insta/Widgets/TextField/textfield_widget.dart';

// import 'package:instagram_ui/widgets/music_widget.dart';

void showMusicBottomSheet(BuildContext context) {
  // initializing the MusicUserController
  MusicUserController musicController = Get.put(MusicUserController());
  // Get audio controller
  AudioController audioController = Get.put(AudioController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // Removes the dark overlay
    barrierColor: Colors.transparent,
    // bottom sheet background color
    backgroundColor: Color(0xFF222328),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            // for loading
            return Obx(() {
              if (musicController.isLoading.value) {
                // return Center(child: CircularProgressIndicator());
                // return SizedBox();
                return Center(
                  child: Lottie.asset(
                    "assets/lottie-images/loading_lottie.json",
                  ),
                );
              }

              // for showing the music list
              return Column(
                children: [
                  // Search bar (fixed)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 15.h,
                    ),
                    child: TextfieldWidget(
                      hintText: "Search music",
                      obscureText: false,
                      inputType: TextInputType.text,
                      onChanged: (value) {
                        musicController.setSearchQuery(value);
                      },
                    ),
                  ),

                  // Scrollable music list
                  Expanded(
                    child: Stack(
                      children: [
                        NotificationListener(
                          onNotification: (scrollNotification) {
                            // Dismiss keyboard on scroll
                            FocusScope.of(context).unfocus();
                            return false;
                          },
                          // Music list with support for 'no results' message
                          child: ListView.builder(
                            controller: scrollController,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            // If no music found, we show just one item (the message)
                            itemCount: musicController.filteredMusicList.isEmpty
                                ? 1
                                : musicController.filteredMusicList.length,
                            itemBuilder: (context, index) {
                              // Show 'No music found' if list is empty
                              if (musicController.filteredMusicList.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 100.h),
                                  child: Center(
                                    child: Text(
                                      'No music found',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Otherwise, build the music item normally
                              final music =
                                  musicController.filteredMusicList[index];
                              return MusicWidget(music: music);
                            },
                          ),
                        ),

                        // Always show the audio player fixed at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AudioPlayerContainerWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
          },
        ),
      );
    },
  ).whenComplete(() {
    // reset the tapped audio when bottom sheet is dismissed
    audioController.resetAudio();
    // clear filtered music list
    musicController.searchQuery.value = '';
  });
}
