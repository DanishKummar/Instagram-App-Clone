import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String userImage;
  final DateTime createdAt;
  final String text;
  final List<String> likedBy;
  final String username;
  final int likeCount;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.userImage,
    required this.text,
    required this.createdAt,
    required this.likedBy,
    required this.likeCount,
    required this.username,
  });
  // ✅ Add this to fix the error
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'text': text,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'like_count': likeCount,
      'likedBy': likedBy,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'createdAt': createdAt,
      'likedBy': likedBy,
      'like_count': likeCount,
      'text': text,
      'userId': userId,
      'userImage': userImage,
      'username': username,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      userId: map['userId'],
      userImage: map['userImage'],
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      likeCount: map['like_count'],
      username: map['username'],
    );
  }
}
