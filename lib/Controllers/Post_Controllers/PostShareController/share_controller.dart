import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ShareController extends GetxController {
  final String dynamicLinkPrefix = 'https://reelflow.page.link';

  /// Share a post with dynamic link, including image and caption.
  Future<void> shareContent({
    required String id,
    required String caption,
    required String mediaUrl,
    required bool isReel,
  }) async {
    try {
      Uri link = await _createDynamicLink(
        id: id,
        caption: caption,
        mediaUrl: mediaUrl,
        isReel: isReel,
      );
      Share.share(link.toString());
    } catch (e) {
      debugPrint('Error while sharing: $e');
    }
  }

  Future<Uri> _createDynamicLink({
    required String id,
    required String caption,
    required String mediaUrl,
    required bool isReel,
  }) async {
    final String route = isReel ? "reel" : "post";

    final Uri fallbackUrl = Uri.parse(
      "https://instagram-clone-f7c19.web.app/$route?id=$id",
    );

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('https://reelflow.page.link/$route?id=$id'),

      androidParameters: AndroidParameters(
        packageName: 'com.example.new_insta',
        fallbackUrl: fallbackUrl,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.example.new_insta',
        fallbackUrl: fallbackUrl,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: caption.isNotEmpty
            ? caption
            : 'Check out this ${isReel ? 'reel' : 'post'} on Reelflow!',
        description: 'Tap to view now.',
        imageUrl: Uri.parse(mediaUrl),
      ),
    );

    final shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
      parameters,
    );
    return shortLink.shortUrl;
  }
}
