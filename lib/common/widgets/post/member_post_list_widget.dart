import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';
import 'package:travel_torum_app/common/widgets/post/post_card.dart'; // Import PostCard
import 'package:travel_torum_app/features/page/posts/services/post_services.dart';

class MemberPostListWidget extends StatelessWidget {
  final String userId;
  const MemberPostListWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lắng nghe PostService
    final postService = context.watch<PostServices>();

    // Lọc danh sách: chỉ lấy bài đăng có author.id == userId
    final List<PostModel> myPosts = postService.posts
        .where((post) => post.author.id == userId)
        .toList();

    if (postService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myPosts.isEmpty) {
      return const Center(
        child: Text("Bạn chưa đăng bài nào."),
      );
    }

    // Tái sử dụng PostCard mà chúng ta đã làm
    return ListView.builder(
      itemCount: myPosts.length,
      itemBuilder: (context, index) {
        return PostCard(post: myPosts[index]);
      },
    );
  }
}