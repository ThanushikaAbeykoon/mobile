import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool isObscured;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const AuthField(
      {super.key,
      required this.hintText,
      required this.isObscured,
      required this.controller,
      this.validator,
      this.onChanged,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPalettes.cardForeground,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
