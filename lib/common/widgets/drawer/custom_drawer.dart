import 'package:flutter/material.dart';
import 'package:travel_torum_app/common/widgets/drawer/custom_drawer_item.dart';
import 'package:travel_torum_app/common/widgets/drawer/custom_drawer_member_profile.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final String last_name;
  final String avt_url;
  final VoidCallback onToggleDrawer;
  final void Function(String) onNavigate;

  const CustomDrawer({
    required this.last_name,
    required this.avt_url,
    required this.onToggleDrawer,
    required this.onNavigate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CustomDrawerMemberProfile(last_name: last_name, avt_url: avt_url),
          CustomDrawerItem(
            icon: 'homeIcon.png',
            title: 'Home',
            onPressed: () => onNavigate('/home'),
          ),
          CustomDrawerItem(
            icon: 'profileIcon.png',
            title: 'Profile',
            onPressed: () => onNavigate('/ProfilePage'),
          ),
        ],
      ),
    );
  }
}
