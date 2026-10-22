import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:new_insta/Models/Music/music_model.dart';

class AudioController extends GetxController with WidgetsBindingObserver {
  // Audio player instance
  final AudioPlayer player = AudioPlayer();

  // ***** Reactive variables to track player state ****
  // Whether audio is playing
  final isPlaying = false.obs;
  // Currently loaded audio URL
  final currentUrl = ''.obs;
  // Loading state for UI indication
  final isLoading = false.obs;
  //  new reactive variable
  final tappedUrl = ''.obs;
  VoidCallback? onAudioCompleted;
  // Used for debounce to prevent rapid taps
  DateTime lastTap = DateTime.now();

  @override
  void onInit() {
    super.onInit();

    // Listen to player state changes and update reactive variables accordingly
    player.playerStateStream.listen((state) {
      final isReady = state.processingState == ProcessingState.ready;
      final isCompleted = state.processingState == ProcessingState.completed;
      // Start listening
      WidgetsBinding.instance.addObserver(this);

      // If audio completed, reset state
      if (isCompleted) {
        isPlaying.value = false;
        currentUrl.value = '';
        // if audio is being completed
        if (onAudioCompleted != null) {
          onAudioCompleted!();
        }
      } else {
        // Update isPlaying when player is ready and playing
        isPlaying.value = player.playing && isReady;
      }
    });
  }

  /// Toggles play/pause behavior based on URL and current state
  Future<void> togglePlayPause(String url) async {
    if (DateTime.now().difference(lastTap).inMilliseconds < 250) return;
    lastTap = DateTime.now();

    tappedUrl.value = url;

    try {
      if (currentUrl.value != url) {
        isLoading.value = true;

        // Fully stop and reset before loading new URL
        await player.stop();
        await player.setLoopMode(LoopMode.off); // just in case

        currentUrl.value = url;

        // Use just_audio_cache to load
        await player.dynamicSet(url: url);

        isLoading.value = false;
        await player.play();
      } else {
        // If same URL tapped again
        if (player.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
          await player.play();
        } else if (player.playing) {
          await player.pause();
        } else {
          await player.play();
        }
      }
    } catch (e, stack) {
      print('❌ Audio playback error: $e');
      print(stack); // full trace for debug
      isLoading.value = false;
    }
  }

  // **** current selected music ****
  Rx<MusicModel?> currentMusic = Rx<MusicModel?>(null);

  void selectMusic(MusicModel music) async {
    currentMusic.value = music;
    tappedUrl.value = music.musicUrl;
    togglePlayPause(music.musicUrl);
  }

  // **** current selected music play in loop ****
  void selectedMusicPlayLoop(MusicModel music) async {
    currentMusic.value = music;
    tappedUrl.value = music.musicUrl;
    await playMusicInLoop(music.musicUrl);
  }

  // ****** This plays the audio on infinite loop ********
  Future<void> playMusicInLoop(String url) async {
    try {
      await player.setUrl(url);
      await player.setLoopMode(LoopMode.one);
      await player.play();
    } catch (e) {
      print("Error playing music in loop : $e");
    }
  }

  // **** reset the audio ****
  void resetAudio() async {
    // stop current playback
    await player.stop();
    // ensure next playback starts from beginning
    await player.seek(Duration.zero);
    // reset tapped URL
    tappedUrl.value = '';
    currentMusic.value = null;
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause the audio when app goes into background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (player.playing) {
        player.pause();
      }
    }
  }

  void pauseAudio() {
    player.pause(); // or whatever your player instance is
  }

  void resumeAudio() {
    player.play();
  }

  @override
  void onClose() {
    // Properly dispose of audio player to free resources
    player.dispose();
    // Clean up
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
