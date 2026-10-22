import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:new_insta/Models/StoryModel/story_model.dart';

class StoryFetchController extends GetxController {
  RxString storyType = ''.obs;

  Future<void> mystory() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_stories')
          .where('user_id', isEqualTo: uid)
          .orderBy('created_at', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        storyType.value = data['story_type'] ?? '';
        print("✅ Story type: ${storyType.value}");
      } else {
        storyType.value = '';
        print("🟡 No story found");
      }
    } catch (e) {
      print("❌ Error fetching story: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    mystory(); // ✅ Fetch once on load
  }
}
