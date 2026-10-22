import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String username;
  final String imageUrl;
  final String? musicUrl;
  final String? userId;
  final DateTime createdAt;
  final String? storyType;

  StoryModel({
    required this.username,
    required this.imageUrl,
    this.musicUrl,
    this.userId,
    required this.createdAt,
    this.storyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'image_url': imageUrl,
      'music_url': musicUrl,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
      'story_type': storyType,
    };
  }

  factory StoryModel.fromFirestore(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : DateTime.tryParse(createdAtRaw.toString()) ?? DateTime.now();

    return StoryModel(
      username: json['username'] ?? '',
      imageUrl: json['image_url'] ?? '',
      musicUrl: json['music_url'],
      userId: json['user_id'],
      createdAt: createdAt,
      storyType: json['story_type'] ?? 'music_cover',
    );
  }

  factory StoryModel.fromMap(Map<String, dynamic> json) =>
      StoryModel.fromFirestore(json);

  factory StoryModel.fromSupabaseJson(Map<String, dynamic> json) {
    return StoryModel(
      username: json['username'] ?? '',
      imageUrl: json['image_url'] ?? '',
      musicUrl: json['music_url'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      storyType: json['story_type'] ?? 'music_cover',
    );
  }
}
