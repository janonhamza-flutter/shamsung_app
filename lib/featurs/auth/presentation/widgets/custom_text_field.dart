import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),
      ),

      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,

        obscureText: obscureText,

        validator: (value) {
          return validator?.call(value ?? "");
        },

        style: const TextStyle(fontSize: 20),

        decoration: InputDecoration(
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          hintText: hint,

          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 20),

          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
