import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxInt followingCount = 0.obs;
  RxBool isFollow = true.obs;
  RxMap<String, RxBool> isFollowingMap = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowingCount();
    loadFollowingStatusForAll();
  }

  //  check that user has followed 5 other user
  bool canAccessFeed() => followingCount.value >= 5;
  // fetching following users
  Future<void> fetchFollowingCount() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = firestore.collection("users").doc(uid);
    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      print("⚠️ User doc doesn't exist, creating one...");
      await userRef.set({
        "uid": uid,
        "username": auth.currentUser?.displayName ?? "Unnamed",
        "email": auth.currentUser?.email ?? "",
        "photoUrl": auth.currentUser?.photoURL ?? "",
        "following": [],
        "createdAt": DateTime.now().toIso8601String(),
      });
      followingCount.value = 0;
      return;
    }

    final data = userDoc.data() as Map<String, dynamic>;
    followingCount.value = (data["following"] as List?)?.length ?? 0;
  }

  bool isFollowing(String userId) {
    return isFollowingMap[userId]?.value ?? false;
  }

  ///  Optimistic toggle follow/unfollow
  Future<void> toggleFollow(String targetUserId) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    final isCurrentlyFollowing = isFollowing(targetUserId);

    //  Step 1: Optimistically update UI immediately
    isFollowingMap[targetUserId] = RxBool(!isCurrentlyFollowing);

    final userRef = firestore.collection('users').doc(currentUserId);

    try {
      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        print("❌ Current user doc doesn't exist.");
        return;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      List<dynamic> following = List.from(data['following'] ?? []);

      if (isCurrentlyFollowing) {
        // Unfollow logic
        following.remove(targetUserId);
        await userRef.update({'following': following});
        print("✅ Unfollowed $targetUserId");
      } else {
        // Follow logic
        following.add(targetUserId);
        await userRef.update({'following': following});
        print("✅ Followed $targetUserId");
      }

      fetchFollowingCount(); // optional
    } catch (e) {
      // ❌ If error, revert the optimistic change
      isFollowingMap[targetUserId] = RxBool(isCurrentlyFollowing);
      print("❌ toggleFollow error: $e");
    }
  }

  Future<void> initFollowStatus(String userId) async {
    if (isFollowingMap.containsKey(userId)) return;

    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null) return;

    final userRef = firestore.collection('users').doc(currentUserId);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      print("⚠️ Current user doc doesn't exist when checking follow status.");
      return;
    }

    final data = snapshot.data() as Map<String, dynamic>;
    final following = data['following'] as List? ?? [];
    isFollowingMap[userId] = RxBool(following.contains(userId));
  }

  Future<void> loadFollowingStatusForAll() async {
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null) return;

    final snapshot = await firestore
        .collection('users')
        .doc(currentUserId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final following = data['following'] as List? ?? [];

      for (String uid in following) {
        isFollowingMap[uid] = true.obs;
      }
    }
  }
}
