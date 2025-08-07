import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const ProfileAvatar({super.key, required this.imageUrl, this.radius = 50.0});

  Future<bool> _checkImageUrl(String url) async {
    if (url.isEmpty) return false;
    try {
      final response = await http
          .head(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkImageUrl(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError || !snapshot.data!) {
          return CircleAvatar(
            radius: radius,
            child: const Icon(Icons.person, size: 40),
          );
        }
        return CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(imageUrl),
        );
      },
    );
  }
}
