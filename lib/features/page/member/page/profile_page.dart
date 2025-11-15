import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_torum_app/common/widgets/member/profile_header_widgets.dart';
import 'package:travel_torum_app/common/widgets/post/like_post_widget.dart';
import 'package:travel_torum_app/common/widgets/post/member_post_list_widget.dart';
import 'package:travel_torum_app/features/page/auth/services/auth_service.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Chúng ta cần DefaultTabController, nên cần dùng StatefulWidget
// hoặc bọc bằng DefaultTabController
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng từ AuthService
    final member = context.watch<AuthService>().member;

    // Nếu vì lý do gì đó member bị null, hiển thị loading
    if (member == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2, // 2 tab: Bài đăng và Đã thích
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(
            "${member.firts_name} ${member.last_name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: AppColors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                context.go('/EditProfile');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            ProfileHeaderWidget(member: member),
            Container(
              color: AppColors.white,
              child: const TabBar(
                tabs: [
                  Tab(text: "Bài đăng"),
                  Tab(text: "Đã thích"),
                ],
                labelColor: AppColors.blue,
                unselectedLabelColor: AppColors.gray2,
                indicatorColor: AppColors.blue,
              ),
            ),
            
            const Divider(height: 1, thickness: 1, color: AppColors.gray),

            Expanded(
              child: TabBarView(
                children: [
                  MemberPostListWidget(userId: member.id),
                  
                  LikedPostListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}