import 'package:flutter/widgets.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/data/model/post/media_model.dart';
import 'package:travel_torum_app/data/model/post/post_comment_model.dart';
import 'package:travel_torum_app/data/model/post/post_like_model.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';

class PostServices extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = true;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PostServices() {
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // báo UI biết đang tải
    try {
      await Future.delayed(const Duration(seconds: 1));
      _posts = _getMockData();
    } catch (e) {
      _error = "Không thể tải bài đăng: $e";
    }
    _isLoading = false;
    notifyListeners();
  } 

  Future<void> _createNewPost(PostModel newPost) async {
    _posts.insert(0, newPost);
    notifyListeners();
  }

  List<PostModel> _getMockData() {
    final mocUser1 = MemberModel(
      id: "m1",
      firts_name: "Lê Việt",
      last_name: "Tiến",
      avata_url:
          "https://res.cloudinary.com/dsrrik0wb/image/upload/v1747806615/gx8b7qdbife2bunei2l4.jpg",
      auth_token: 'abc123',
    );

    final mocMedia1 = MediaModel(
      type: "image",
      url:
          "https://res.cloudinary.com/dsrrik0wb/image/upload/v1744033364/samples/coffee.jpg",
    );

    final mocLike1 = PostLikeModel(
      id: "like1",
      create_at: DateTime.now().subtract(const Duration(days: 1)),
    );

    final mocComment1 = PostCommentModel(
      id: "Comment1",
      content: "Very Good Post",
      create_at: DateTime.now().subtract(const Duration(days: 1)),
    );
    return [
      PostModel(
        id: 'p1',
        title: 'Kinh nghiệm phượt Hà Giang mùa hoa tam giác mạch',
        contentPreview:
            'Hà Giang luôn đẹp, nhưng đẹp nhất là mùa hoa... Mọi ngóc ngách đều phủ một màu tím hồng mộng mơ.',
        content:
            'Hà Giang luôn đẹp, nhưng đẹp nhất là mùa hoa... Mọi ngóc ngách đều phủ một màu tím hồng mộng mơ.',
        author: mocUser1,
        create_at: DateTime.now().subtract(const Duration(days: 1)),
        media: [mocMedia1],
        like: [mocLike1],
        comment: [mocComment1],
      ),
      PostModel(
        id: 'p2',
        title: 'Top 5 món ăn phải thử khi đến Đà Nẵng',
        contentPreview:
            'Bánh tráng cuốn thịt heo, mì Quảng, bún mắm... là những món ăn bạn không thể bỏ qua. Hãy cùng khám phá!',
        content:
            'Bánh tráng cuốn thịt heo, mì Quảng, bún mắm... là những món ăn bạn không thể bỏ qua. Hãy cùng khám phá!',
        author: mocUser1,
        create_at: DateTime.now().subtract(const Duration(days: 1)),
        media: [mocMedia1],
        like: [mocLike1],
        comment: [mocComment1],
      ),
    ];
  }
}
