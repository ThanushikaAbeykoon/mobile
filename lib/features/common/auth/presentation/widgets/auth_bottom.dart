import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class AuthBottom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String linkText;

  const AuthBottom({
    super.key,
    required this.text,
    required this.onPressed,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              linkText,
              style: TextStyle(
                color: AppPalettes.accent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
