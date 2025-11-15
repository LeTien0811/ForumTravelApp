class MediaModel {
  final String type;
  final String url;

  const MediaModel({required this.type, required this.url});

  // (Trong file media_model.dart)
  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(url: json['url'] ?? '', type: json['type']);
  }
}
