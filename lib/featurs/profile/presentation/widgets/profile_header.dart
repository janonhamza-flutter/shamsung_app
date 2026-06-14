import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundColor: AppColors.green,

          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),

        const SizedBox(height: 15),

        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(email, style: TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }
}
