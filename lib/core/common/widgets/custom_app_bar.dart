import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  CustomAppBar({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppPalettes.accent,
        ),
      ),
      backgroundColor: AppPalettes.primary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
