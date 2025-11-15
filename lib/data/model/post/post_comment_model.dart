class PostCommentModel {
  final String id;
  final String content;
  final DateTime create_at;

  const PostCommentModel({
    required this.id,
    required this.content,
    required this.create_at
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(id: json['id'], content: json['content'], create_at: json['create_at']);
  }
}