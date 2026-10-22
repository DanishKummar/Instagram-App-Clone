import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class SeeStoryView extends StatefulWidget {
  final String? imageUrl;
  final String? musicUrl;
  final String? username;
  final String? storyType;

  const SeeStoryView({
    super.key,
    this.imageUrl,
    this.musicUrl,
    this.username,
    this.storyType,
  });

  @override
  State<SeeStoryView> createState() => _SeeStoryViewState();
}

class _SeeStoryViewState extends State<SeeStoryView>
    with TickerProviderStateMixin {
  late AudioPlayer player;
  late AnimationController rotationController;
  late AnimationController progressController;

  bool isNetworkStoryImage = false;
  bool isMusicOnlyStory = false;

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..addListener(() {
            setState(() {});
          });

    _handleStoryCase();
    _startMusicIfAvailable();

    progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.back(); // You can replace with goToNext()
      }
    });

    progressController.forward();
  }

  void _handleStoryCase() {
    final type = widget.storyType;
    final hasImageUrl = widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    if ((type == null || type.trim().isEmpty) && hasImageUrl) {
      // Music story with cover image
      isMusicOnlyStory = true;

      // Start rotation after widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          rotationController.repeat();
        }
      });
    } else if (type != null && type.startsWith("http")) {
      isNetworkStoryImage = true;
    }
  }

  void _startMusicIfAvailable() async {
    if (widget.musicUrl != null && widget.musicUrl!.isNotEmpty) {
      try {
        await player.setUrl(widget.musicUrl!);
        await player.play();
      } catch (e) {
        print("[Audio Error]: $e");
      }
    }

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        Get.back(); // You can replace with goToNext()
      }
    });
  }

  void handleLongPress(bool isPressed) {
    if (isPressed) {
      player.pause();
      rotationController.stop();
      progressController.stop();
    } else {
      player.play();
      rotationController.repeat();
      progressController.forward();
    }
  }

  @override
  void dispose() {
    player.dispose();
    rotationController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl ?? '';
    final username = widget.username ?? 'Unknown';

    return GestureDetector(
      onLongPress: () => handleLongPress(true),
      onLongPressUp: () => handleLongPress(false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              /// ✅ Background Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: isNetworkStoryImage ? widget.storyType! : imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),

              /// ✅ Blur + Gradient for Music-only Story
              if (isMusicOnlyStory) ...[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],

              /// ✅ Top Progress Bar
              Positioned(
                top: 10.h,
                left: 10.w,
                right: 10.w,
                child: LinearProgressIndicator(
                  value: progressController.value,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

              /// ✅ Header Info
              Positioned(
                top: 25.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              /// ✅ Rotating Music Disc
              if (isMusicOnlyStory)
                Center(
                  child: RotationTransition(
                    turns: Tween(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(rotationController),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/disc.png",
                          width: 300.w,
                          fit: BoxFit.cover,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 180.w,
                            height: 180.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              /// ✅ Bottom Username (for storyType network image only)
              if (isNetworkStoryImage)
                Positioned(
                  bottom: 40.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
