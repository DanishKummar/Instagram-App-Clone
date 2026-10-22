import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  final String userUid;
  final String reelId;
  final int commentCount;
  final int likeCount;
  final DateTime createdAt;
  final String videoUrl;
  final String? musicArtist;
  final String? musicCoverimage;
  final String? musicUrl;
  final String? musicTitle;
  final bool muteOriginalAudio;
  final String caption;

  ReelModel({
    required this.userUid,
    required this.reelId,
    required this.commentCount,
    required this.likeCount,
    required this.createdAt,
    required this.videoUrl,
    required this.caption,
    this.musicArtist,
    this.musicCoverimage,
    this.musicUrl,
    this.musicTitle,
    this.muteOriginalAudio = false,
  });

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      userUid: map['userUid'],
      reelId: map['reelId'],
      commentCount: map['commentCount'],
      likeCount: map['likeCount'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      videoUrl: map['videoUrl'],
      caption: map['caption'],
      musicArtist: map['musicArtist'],
      musicCoverimage: map['musicCoverImage'],
      musicUrl: map['musicUrl'],
      musicTitle: map['musicTitle'],
      muteOriginalAudio: map['mute_original_audio'] ?? false,
    );
  }
}
