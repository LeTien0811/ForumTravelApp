import 'package:flutter/material.dart';

class LikedPostListWidget extends StatelessWidget {
  const LikedPostListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Khi có service, em sẽ lấy danh sách bài đã thích ở đây
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Tính năng 'Bài đã thích' đang được phát triển!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}