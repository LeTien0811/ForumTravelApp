import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_torum_app/common/widgets/drawer/custom_drawer.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/features/layout/main_layout.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final MemberModel member;
  final VoidCallback logoutCallBack;

  const AppShell({
    required this.child,
    required this.member,
    required this.logoutCallBack,
    super.key,
  });

  @override
  State<AppShell> createState() => _AppShell();
}

class _AppShell extends State<AppShell> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  
  @override
  void initState() {
    super.initState();
    // quan ly aniamtion
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

// quan ly aniamtion
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

// quan ly draw
  void _toggleDrawer() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

// quan ly router
  void _onNavigate(String path) {
    // Dùng GoRouter để điều hướng
    context.go(path);
    // Đóng drawer sau khi điều hướng
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    const bool isAppBarVisible = true;
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: AppColors.white,
        child: Stack(
          children: <Widget>[
            // hien thi drawer
            CustomDrawer(
              last_name: widget.member.last_name,
              avt_url: widget.member.avata_url,
              onToggleDrawer: _toggleDrawer,
              onNavigate: _onNavigate,
            ),

            // layout
            MainLayout(
              onPressed: _toggleDrawer,
              animationController: _animationController,
              body: widget.child,
              isAppBar: isAppBarVisible,
            ),
          ],
        ),
      ),
    );
  }
}
