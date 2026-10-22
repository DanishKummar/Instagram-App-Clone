import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_insta/Views/SharePostView/share_post_view.dart';
import 'package:new_insta/Views/ShareReelView/share_reel_view.dart';

class DynamicLinkService {
  static Future<void> initDynamicLinks() async {
    // 1. Handle link when app is in background / foreground
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData data) {
          _handleDynamicLink(data.link);
        })
        .onError((error) {
          debugPrint('Dynamic Link Failed: $error');
        });

    // 2. Handle link when app is opened from terminated state
    final PendingDynamicLinkData? initialData = await FirebaseDynamicLinks
        .instance
        .getInitialLink();
    if (initialData != null) {
      _handleDynamicLink(initialData.link);
    }
  }

  static void _handleDynamicLink(Uri deepLink) {
    final id = deepLink.queryParameters['id'];

    if (id != null) {
      if (deepLink.path.contains('post')) {
        Get.to(() => SharePostView(postId: id));
      } else if (deepLink.path.contains('reel')) {
        Get.to(() => ShareReelView(reelId: id));
      }
    }
  }
}
