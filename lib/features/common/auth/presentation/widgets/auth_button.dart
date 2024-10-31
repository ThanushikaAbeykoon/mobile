import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed; // Allow onPressed to be nullable
  final bool isLoading; // Add isLoading parameter

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, // Default isLoading to false
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            widget.isLoading ? null : widget.onPressed, // Disable when loading
        style: ElevatedButton.styleFrom(
          primary: AppPalettes.primary,
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: widget.isLoading // Show loader if loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
