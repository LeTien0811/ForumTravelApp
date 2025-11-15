import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/assets/app_imgs.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CircleAppButtonNew extends StatelessWidget {
  final VoidCallback onPressed;
  
  const CircleAppButtonNew({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(64, 64),
        backgroundColor: AppColors.yellow,
        elevation: 5,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
      ),
      child: ImageIcon(
        AssetImage(
          '${AppImages.basePath}plusIcon.png'),
          color: AppColors.black, 
          size: 24,
      ),
    );
  }
}