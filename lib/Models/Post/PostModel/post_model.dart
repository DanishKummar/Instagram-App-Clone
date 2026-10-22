import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_insta/Models/Post/PostMediaItems/media_items.dart';

class PostModel {
  final String userUid;
  final String postId;
  final String username;
  final String userImage;
  final String caption;
  final DateTime createdAt;
  final int commentCount;
  final int likeCount;
  final List<MediaItem> mediaItems;
  final String? musicUrl;
  final String? musicTitle;
  final String? musicArtist;
  final List<String> likes;
  PostModel({
    required this.userUid,
    required this.postId,
    required this.username,
    required this.userImage,
    required this.caption,
    required this.createdAt,
    required this.commentCount,
    required this.likeCount,
    required this.mediaItems,
    required this.likes,
    this.musicArtist,
    this.musicTitle,
    this.musicUrl,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      userUid: map['user_uid'],
      postId: map['post_id'],
      username: map['username'],
      userImage: map['user_image'],
      caption: map['caption'],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      commentCount: map['comments_count'],
      likeCount: map['like_count'],
      mediaItems: List<Map<String, dynamic>>.from(
        map['media_items'],
      ).map((e) => MediaItem.fromMap(e)).toList(),
      likes: List<String>.from(map['likes'] ?? []),
      musicArtist: map['music_artist'],
      musicTitle: map['music_title'],
      musicUrl: map['music_url'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'post_id': postId,
      'username': username,
      'user_image': userImage,
      'caption': caption,
      'created_at': createdAt,
      'comments_count': commentCount,
      'like_count': likeCount,
      'media_items': mediaItems.map((e) => e.toMap()).toList(),
      'likes': likes,
      'music_artist': musicArtist,
      'music_title': musicTitle,
      'music_url': musicUrl,
    };
  }
}
