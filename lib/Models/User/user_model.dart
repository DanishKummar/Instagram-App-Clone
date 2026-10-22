import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final DateTime createdAt;
  final List<String> following;
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.following,
  });
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'email': email,
    'photoUrl': photoUrl,
    'createdAt': Timestamp.fromDate(createdAt),
    'following': following,
  };
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
