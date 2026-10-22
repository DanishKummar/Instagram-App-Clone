import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/StoryModel/story_model.dart';

class StoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Stores stories of users the current user is following
  RxList<StoryModel> followedStories = <StoryModel>[].obs;

  // Indicates loading state (e.g., when fetching stories)
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    // Fetch followed users' stories when controller initializes
    await fetchFollowedStories();
    super.onInit();
  }

  Future<void> fetchFollowedStories() async {
    isLoading.value = true;

    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) return;

      final userDoc = await firestore
          .collection("users")
          .doc(currentUser.uid)
          .get();
      if (!userDoc.exists) return;

      List<dynamic> following = userDoc.data()?['following'] ?? [];

      if (following.isEmpty) {
        followedStories.clear();
        return;
      }

      // Get all stories from followed users
      final snapshot = await firestore
          .collection('user_stories')
          .where('user_id', whereIn: following)
          .get();

      final now = DateTime.now();
      final expiryTime = now.subtract(Duration(hours: 24));

      // Filter out expired stories
      final validStories = snapshot.docs
          .where((doc) {
            final data = doc.data();
            if (!data.containsKey('created_at')) return false;
            final timestamp = data['created_at'];
            if (timestamp is! Timestamp) return false;

            final storyDate = timestamp.toDate();
            return storyDate.isAfter(expiryTime);
          })
          .map((doc) => StoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      followedStories.value = validStories;
    } catch (e) {
      print("❌ Error fetching filtered stories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //  Delete stories older than 24 hours from 'user_stories' collection
  // Note: This is typically run by an admin or background service
  Future<void> deleteExpiredStories() async {
    final now = DateTime.now();
    final expiryTime = now.subtract(Duration(hours: 48));
    final currentUser = auth.currentUser;

    if (currentUser == null) return;

    // Fetch only *this user's* expired stories
    final snapshot = await firestore
        .collection('user_stories')
        .where('user_id', isEqualTo: currentUser.uid)
        .where('created_at', isLessThan: Timestamp.fromDate(expiryTime))
        .get();

    for (final doc in snapshot.docs) {
      await firestore.collection('user_stories').doc(doc.id).delete();
    }
  }
}
