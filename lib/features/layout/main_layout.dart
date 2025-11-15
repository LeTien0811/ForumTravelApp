import 'package:flutter/material.dart';
import 'package:travel_torum_app/common/widgets/appbar/app_bar_custom.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final VoidCallback onPressed;
  final AnimationController animationController;
  final double maxDrawerWidth;
  final double maxScale;    
  final Widget body;
  final bool isAppBar;

  const MainLayout({
    required this.onPressed,
    required this.animationController,
    required this.body,
    required this.isAppBar,
    this.maxDrawerWidth = 250.0, 
    this.maxScale = 0.9,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final scale = 1.0 - (1.0  - maxScale) * animationController.value;
        final translateX = maxDrawerWidth * animationController.value;

        return Transform(
          transform: Matrix4.identity()
          ..translate(translateX)
          ..scale(scale),
          alignment: Alignment.centerLeft,
          child: AbsorbPointer(
            absorbing: animationController.isAnimating || animationController.isCompleted,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(animationController.value * 20.0),
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: isAppBar ? AppBarCustom(onPressed: onPressed,) : null,
                body: body,
              ),
            ),
          ),
        );
      },
    );
  }
}