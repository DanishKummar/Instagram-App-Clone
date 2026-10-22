import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyStoryController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString? storyImageUrl = RxString('');
  RxString? storyMusicUrl = RxString('');
  RxBool hasStory = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserStory();
  }

  void fetchUserStory() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('user_stories')
        .where(
          'user_id',
          isEqualTo: userId,
        ) // Notice: match Firestore field key
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first;
            final imageUrl =
                doc['image_url']; // match your Firestore key exactly
            final musicUrl =
                doc['music_url']; // match your Firestore key exactly
            storyImageUrl?.value = imageUrl;
            storyMusicUrl?.value = musicUrl;
            hasStory.value = true;
          } else {
            storyImageUrl?.value = '';
            storyMusicUrl?.value = '';
            hasStory.value = false;
          }
        });
  }
}
