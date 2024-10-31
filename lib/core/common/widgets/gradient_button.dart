import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/arena/presentation/booked_arena.dart';

class DraggableButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const DraggableButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppPalettes.foreground, AppPalettes.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
