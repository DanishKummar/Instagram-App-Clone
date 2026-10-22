class MediaItem {
  final String type;
  final String url;

  MediaItem({required this.type, required this.url});
  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(type: map['type'], url: map['url']);
  }
  Map<String, dynamic> toMap() {
    return {'type': type, 'url': url};
  }
}
