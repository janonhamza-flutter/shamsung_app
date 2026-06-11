import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;

  final String title;

  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blue,

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: Icon(icon, color: AppColors.green),

        title: Text(title, style: const TextStyle(color: Colors.white)),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 18,
        ),

        onTap: onTap,
      ),
    );
  }
}
