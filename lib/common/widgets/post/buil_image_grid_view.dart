import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:travel_torum_app/core/config/theme/app_colors.dart'; // Chỉ dùng cho mobile

class ImageGridView extends StatelessWidget {
  final List<XFile> images;
  final void Function(int) onRemoveImage;
  const ImageGridView({
    super.key,
    required this.images,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      itemCount: images.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final xfile = images[index];
        Widget imageWidget;
        if (kIsWeb) {
          imageWidget = Image.network(
            xfile.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        } else {
          imageWidget = Image.file(
            File(xfile.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageWidget,
            ),
            Positioned(
              top: 4,  // Set vị trí
              right: 4, // Set vị trí
              child: GestureDetector(
                onTap: () => onRemoveImage(index),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.clear_sharp,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
