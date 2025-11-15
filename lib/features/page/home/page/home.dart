import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_torum_app/common/widgets/circle_button/circle_app_button_new.dart';
import 'package:travel_torum_app/common/widgets/post/post_list.dart';
import 'package:travel_torum_app/features/page/posts/services/post_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final postServices = context.watch<PostServices>();
    return Scaffold(
      body: _buildBody(postServices),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent, // 🟢 làm trong suốt
        elevation: 0, // 🟢 bỏ bóng mờ
        highlightElevation: 0,
        shape: const CircleBorder(),
        child: CircleAppButtonNew(
          onPressed: () {
            context.go('/makePostScreen');
          },
        ),
      ),
    );
  }

  Widget _buildBody(PostServices postService) {
    if (postService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (postService.error != null) {
      return Center(child: Text(postService.error!));
    }

    if (postService.posts.isEmpty) {
      return const Center(child: Text("Chưa có bài đăng nào."));
    }

    // 3. Hiển thị danh sách từ service
    return PostList(posts: postService.posts);
  }
}
