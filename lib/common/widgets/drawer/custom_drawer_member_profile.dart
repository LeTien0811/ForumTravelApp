import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CustomDrawerMemberProfile extends StatelessWidget {
  final String last_name;
  final String avt_url;

  const CustomDrawerMemberProfile({
    required this.last_name,
    required this.avt_url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text( 
        last_name, 
        style: const TextStyle(
            color: AppColors.black
          ),
      ),

      accountEmail: const Text(''),

      currentAccountPicture: CircleAvatar(
        backgroundColor: AppColors.white,
        backgroundImage: NetworkImage(avt_url),
      ), 

      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
    );
  }
}