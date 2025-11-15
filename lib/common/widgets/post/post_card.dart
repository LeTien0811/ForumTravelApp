import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_torum_app/core/config/assets/app_imgs.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    final String? coverImageUrl = post.coverImageUrl;
    return Card(
      child: InkWell(
        onTap: () {
          context.go('/postDetail', extra: post);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (coverImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.network(
                  coverImageUrl,
                  height: 160,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: AppColors.gray,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, child, StackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.gray,
                      child: Icon(Icons.broken_image, color: AppColors.gray),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[600],
                  size: 50,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.author.avata_url),
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.last_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Đăng lúc ${post.create_at.day}/${post.create_at.month}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: AppColors.gray2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Text(
                post.contentPreview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AppImages.basePath + 'loveIcon.png',
                          width: 16.5,
                          height: 13.5,
                        ),
                        const SizedBox(width: 3),
                        Text(post.comment.length.toString()),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AppImages.basePath + 'commentIcon.png',
                          width: 16.5,
                          height: 13.5,
                        ),
                        const SizedBox(width: 3),
                        Text(post.like.length.toString()),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {},
                    child: Image.asset(
                      AppImages.basePath + 'saveIcon.png',
                      width: 16.5,
                      height: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
