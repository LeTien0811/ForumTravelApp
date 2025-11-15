import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa trang cá nhân"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context); 
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 150,
              color: AppColors.gray,
              child: const Center(child: Text("Nhấn để thay đổi ảnh bìa")),
            ),
            
            const SizedBox(height: 16),
            
            const CircleAvatar(
              radius: 50,
              child: Text("Nhấn"),
            ),
            
            const SizedBox(height: 24),
            
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: "Tên"),
            ),
            
            const SizedBox(height: 16),

            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: "Họ"),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              decoration: const InputDecoration(labelText: "Giới thiệu (Bio)"),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}