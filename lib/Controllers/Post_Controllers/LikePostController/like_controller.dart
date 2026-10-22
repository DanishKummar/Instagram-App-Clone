import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LikeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Post Likes
  RxMap<String, int> likeCountMap = <String, int>{}.obs;
  RxSet<String> likedPosts = <String>{}.obs;

  // Comment Likes
  RxMap<String, int> commentLikeCountMap = <String, int>{}.obs;
  RxSet<String> likedComments = <String>{}.obs;

  String get uid => _auth.currentUser?.uid ?? "";

  /// -------------------- POST LIKE FUNCTIONS --------------------

  bool hasLiked(String postId) => likedPosts.contains(postId);

  Future<void> loadLikes(String postId) async {
    if (uid.isEmpty) return;

    final postRef = _firestore.collection('user_post').doc(postId);
    final snapshot = await postRef.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final likes = List<String>.from(data['likes'] ?? []);
      final count = data['like_count'] ?? 0;

      likeCountMap[postId] = count;

      if (likes.contains(uid)) {
        likedPosts.add(postId);
      } else {
        likedPosts.remove(postId);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    if (uid.isEmpty) return;

    final postRef = _firestore.collection('user_post').doc(postId);
    final isLiked = likedPosts.contains(postId);
    final currentCount = likeCountMap[postId] ?? 0;

    if (isLiked) {
      likedPosts.remove(postId);
      likeCountMap[postId] = currentCount - 1;
    } else {
      likedPosts.add(postId);
      likeCountMap[postId] = currentCount + 1;
    }

    try {
      await postRef.update({
        'likes': isLiked
            ? FieldValue.arrayRemove([uid])
            : FieldValue.arrayUnion([uid]),
        'like_count': isLiked ? currentCount - 1 : currentCount + 1,
      });
    } catch (e) {
      print("Error updating post like: $e");
      if (isLiked) {
        likedPosts.add(postId);
        likeCountMap[postId] = currentCount;
      } else {
        likedPosts.remove(postId);
        likeCountMap[postId] = currentCount;
      }
    }
  }

  /// -------------------- COMMENT LIKE FUNCTIONS --------------------

  bool hasLikedComment(String commentId) => likedComments.contains(commentId);

  Future<void> loadCommentLikes(String postId, String commentId) async {
    if (uid.isEmpty) return;

    final commentRef = _firestore
        .collection('user_post')
        .doc(postId)
        .collection('comment')
        .doc(commentId);

    final snapshot = await commentRef.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final likes = List<String>.from(data['likedBy'] ?? []);
      final count = data['like_count'] ?? 0;

      commentLikeCountMap[commentId] = count;

      if (likes.contains(uid)) {
        likedComments.add(commentId);
      } else {
        likedComments.remove(commentId);
      }
    }
  }

  Future<void> toggleCommentLike(String postId, String commentId) async {
    if (uid.isEmpty) return;

    final commentRef = _firestore
        .collection('user_post')
        .doc(postId)
        .collection('comment')
        .doc(commentId);

    final isLiked = likedComments.contains(commentId);
    final currentCount = commentLikeCountMap[commentId] ?? 0;

    if (isLiked) {
      likedComments.remove(commentId);
      commentLikeCountMap[commentId] = currentCount - 1;
    } else {
      likedComments.add(commentId);
      commentLikeCountMap[commentId] = currentCount + 1;
    }

    try {
      await commentRef.update({
        'likedBy': isLiked
            ? FieldValue.arrayRemove([uid])
            : FieldValue.arrayUnion([uid]),
        'like_count': isLiked ? currentCount - 1 : currentCount + 1,
      });
    } catch (e) {
      print("Error updating comment like: $e");
      if (isLiked) {
        likedComments.add(commentId);
        commentLikeCountMap[commentId] = currentCount;
      } else {
        likedComments.remove(commentId);
        commentLikeCountMap[commentId] = currentCount;
      }
    }
  }
}
