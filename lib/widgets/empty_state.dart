import 'package:flutter/material.dart';
import '../constants/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    this.message = 'No Data Found',
    this.icon = Icons.inbox,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textLight.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
