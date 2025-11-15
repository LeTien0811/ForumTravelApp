import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final MemberModel member;
  const ProfileHeaderWidget({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ảnh bìa giả lập (em thay bằng URL thật từ member model nhé)
    const String mockCoverUrl = "https://images.unsplash.com/photo-1517760444937-f6397edcbbcd?fit=crop&w=1400&q=80";

    return Column(
      children: [
        SizedBox(
          // Dùng Stack để ảnh bìa và avatar chồng lên nhau
          height: 260, // Chiều cao (Bìa 200 + Avatar 50 + Tên 10)
          child: Stack(
            clipBehavior: Clip.none, // Cho phép avatar tràn ra ngoài
            alignment: Alignment.center,
            children: [
              // 1. Ảnh bìa
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: CachedNetworkImageProvider(mockCoverUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              // 2. Ảnh đại diện (nằm đè lên ảnh bìa)
              Positioned(
                bottom: -0, // Nằm chồng lên trên tên
                child: Column(
                  children: [
                    // Vòng tròn trắng làm viền (giống Facebook)
                    CircleAvatar(
                      radius: 54, // Lớn hơn avatar 4px
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                        radius: 50, // Kích thước avatar
                        backgroundImage: CachedNetworkImageProvider(
                          member.avata_url,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 3. Tên người dùng (nằm dưới avatar)
                    Text(
                      "${member.firts_name} ${member.last_name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}