import 'package:flutter/material.dart';
import 'package:travel_torum_app/common/widgets/post/post_card.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';

class PostList extends StatelessWidget {
  final List<PostModel> posts;
  const  PostList({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    if(posts.isEmpty) {
      return const Center(
        child: Text("Chưa có bài đăng nào"),
      );
    } else {
      return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return PostCard(post: post);          
        },
      );
    }
    
  }
}