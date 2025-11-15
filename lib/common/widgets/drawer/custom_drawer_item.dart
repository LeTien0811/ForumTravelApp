import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/assets/app_imgs.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CustomDrawerItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPressed;

  const CustomDrawerItem({
    required this.icon,
    required this.title,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        AppImages.basePath + icon,
        width: 17.25,
        height: 18.52,
      ),

      title: Text(
        title,
        style: TextStyle(
          color: AppColors.primary, 
          fontWeight: FontWeight.bold
        ),
      ),

      onTap: onPressed,
    );
  }
}
