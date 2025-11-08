import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class MediumAppButtonPrimary extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double ? width; 

  const MediumAppButtonPrimary({
    required this.onPressed,
    required this.title,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 91, 37),
        backgroundColor: AppColors.yellow,
        side: const BorderSide(
          color: AppColors.burnedYellow,
          width: 1
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
      ),
      child: Text(title));
  }
}