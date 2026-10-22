class MusicModel {
  final String id;
  final String title;
  final String artist;
  final String musicUrl;
  final String? coverImage;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.musicUrl,
    this.coverImage,
  });

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      musicUrl: map['music_url'],
      coverImage: map['cover_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'music_url': musicUrl,
      'cover_image': coverImage,
    };
  }
}
