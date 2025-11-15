import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_torum_app/core/config/assets/app_imgs.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  const AppBarCustom({
    required this.onPressed,
    super.key
    });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(

      elevation: 0,
      leading: IconButton(
        onPressed: onPressed,
        icon: Image.asset(AppImages.basePath + 'burgerIcon.png', width: 16.5, height: 13.5)),

      centerTitle: true,
      title: SvgPicture.asset(
          AppImages.logoImg,

          height: 120,
        ),

      actions: <Widget>[
        IconButton(
          onPressed: () { print("Search view"); }, 
          icon: Image.asset(AppImages.basePath + 'searchIcon.png', width: 17.75, height: 17.75) 
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}