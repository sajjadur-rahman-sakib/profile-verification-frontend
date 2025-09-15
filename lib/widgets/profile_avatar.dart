import 'package:flutter/material.dart';
import 'package:verify/utils/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const ProfileAvatar({super.key, required this.imageUrl, this.radius = 50.0});

  String _normalizeUrl(String url) {
    if (url.isEmpty) return '';

    url = url.replaceAll(RegExp(r'(?<!:)//+'), '/');

    url = url.replaceAll('\\', '/');

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://10.0.2.2:8080/$url';
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _normalizeUrl(imageUrl),
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.secondaryColor,
          child: Icon(
            Icons.person,
            size: radius * 1.2,
            color: AppColors.iconColor,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return ClipOval(child: child);
        }
        return CircleAvatar(
          radius: radius,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
