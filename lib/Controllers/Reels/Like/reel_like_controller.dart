import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReelLikeController extends GetxController {
  final String reelId;

  RxInt likeCount = 0.obs;
  RxBool isLiked = false.obs;

  ReelLikeController(this.reelId);

  @override
  void onInit() {
    super.onInit();
    fetchLikeCount();
  }

  // Fetch initial like count from Firestore
  Future<void> fetchLikeCount() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user_reels')
          .doc(reelId)
          .get();

      if (doc.exists && doc.data() != null) {
        likeCount.value = doc['likeCount'] ?? 0;
      }
    } catch (e) {
      print("Error fetching like count: $e");
    }
  }

  // Toggle like and update Firestore
  Future<void> toggleLike() async {
    try {
      isLiked.value = !isLiked.value;

      if (isLiked.value) {
        likeCount.value++;
      } else {
        likeCount.value--;
      }

      await FirebaseFirestore.instance
          .collection('user_reels')
          .doc(reelId)
          .update({'likeCount': likeCount.value});
    } catch (e) {
      print("Error toggling like: $e");
    }
  }
}
