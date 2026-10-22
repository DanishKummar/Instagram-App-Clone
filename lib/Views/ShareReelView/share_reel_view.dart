import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/post/post_component.dart';
import 'package:new_insta/Controllers/Post_Controllers/Post_FetchController/post_fetch_controller.dart';
import 'package:new_insta/Controllers/Reels/reel_controller.dart';
import 'package:new_insta/Customs/Appbar/custom_appbar.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';
import 'package:new_insta/Models/Reels/reel_model.dart';
import 'package:new_insta/Widgets/Reels/reels_widget.dart';

class ShareReelView extends StatelessWidget {
  final String? reelId;

  const ShareReelView({super.key, this.reelId});

  @override
  Widget build(BuildContext context) {
    final PostFetchController postFetchController = Get.put(
      PostFetchController(),
    );

    final ReelController reelController = Get.put(ReelController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppbar(
              showLeading: true,
              leadingIcon: 'assets/icons/go_back.png',
              leadingWidth: 25.w,
              leadingHeight: 25.h,
              onLeadingPressed: () => Get.back(),
              showTitle: true,
              title: Center(
                child: Image.asset('assets/images/insta-black-mode-logo.png'),
              ),
            ),
            Expanded(
              child: FutureBuilder<ReelModel?>(
                future: reelController.fetchReelById(reelId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("Reel not found"));
                  }

                  final reel = snapshot.data!;
                  return ReelsWidget(reel: reel, reels: [reel]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
