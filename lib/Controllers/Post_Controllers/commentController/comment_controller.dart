import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/Post/commentModel/comment_model.dart';

class CommentController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  // ***************** Get comments as a stream (live updates) *******************
  Stream<List<CommentModel>> streamComments(String postId) {
    return FirebaseFirestore.instance
        .collection('user_post')
        .doc(postId)
        .collection('comment')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CommentModel.fromMap(doc.data());
          }).toList();
        });
  }

  // ***************** Add comment *******************
  Future<void> addComment({
    required String postId,
    required String text,
    required String userId,
    required String username,
    required String userImage,
  }) async {
    try {
      final commentRef = firestore
          .collection('user_post')
          .doc(postId)
          .collection('comment')
          .doc(); // Auto ID

      final commentId = commentRef.id;

      final newComment = CommentModel(
        commentId: commentId,
        userId: userId,
        userImage: userImage,
        text: text,
        createdAt: DateTime.now(),
        likedBy: [],
        likeCount: 0,
        username: username,
      );

      await commentRef.set(newComment.toMap());

      // 🔁 Optionally, update post's comment count
      final postRef = firestore.collection('user_post').doc(postId);
      await postRef.update({'comments_count': FieldValue.increment(1)});
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}
