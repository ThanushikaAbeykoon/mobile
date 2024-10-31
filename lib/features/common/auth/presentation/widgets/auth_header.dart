import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String titleDesc;
  const AuthHeader({super.key, required this.title, required this.titleDesc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Center(
              child: Icon(
                Icons.sports_volleyball,
                size: 80,
                color: AppPalettes.primary,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Playhub",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Welcome Back Title
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          titleDesc,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
