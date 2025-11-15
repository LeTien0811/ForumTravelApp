class PostLikeModel {
  final String id;
  final DateTime create_at;

  const PostLikeModel({required this.id, required this.create_at});

  factory PostLikeModel.fromJson(Map<String, dynamic> json) {
    return PostLikeModel(id: json['id'] ?? '', create_at: json['create_at']);
  }
}
