import 'package:travel_torum_app/data/model/post/media_model.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/data/model/post/post_comment_model.dart';
import 'package:travel_torum_app/data/model/post/post_like_model.dart';

class PostModel {
  final String id;
  final String title;
  final String contentPreview;
  final String content;
  final MemberModel author;
  final DateTime create_at;
  final List<MediaModel> media;
  final List<PostLikeModel> like;
  final List<PostCommentModel> comment;

  const PostModel({
    required this.id,
    required this.author,
    required this.content,
    required this.contentPreview,
    required this.title,
    required this.create_at,
    required this.media,
    required this.like,
    required this.comment,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var mediaListFromJson = json['media'] as List? ?? [];
    
    List<MediaModel> mediaList = mediaListFromJson
        .map((mediaJson) => MediaModel.fromJson(mediaJson))
        .toList();
    
    var postLikeListFromJson = json['like'] as List? ?? [];
    List<PostLikeModel> postLikeList = postLikeListFromJson
        .map((likeJson) => PostLikeModel.fromJson(likeJson))
        .toList();

    var postCommentListFromJson = json['like'] as List? ?? [];
    List<PostCommentModel> postCommentList = postCommentListFromJson
        .map((cmJson) => PostCommentModel.fromJson(cmJson))
        .toList();

    return PostModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      contentPreview: json['contentPreview'] ?? '',
      content: json['content'] ?? '',
      author: MemberModel.fromJson(json['author']), 
      create_at: DateTime.parse(json['create_at']),
      media: mediaList, 
      like: postLikeList,
      comment: postCommentList
    );
  }

  String? get coverImageUrl {
    // 1. Thử tìm media đầu tiên LÀ HÌNH ẢNH
    try {
      // Dùng firstWhere để tìm media đầu tiên có type là image
      final MediaModel firstImage = media.firstWhere(
        (item) => item.type == "image",
      );
      return firstImage.url;
    } catch (e) {
      return null;
    }
  }
}