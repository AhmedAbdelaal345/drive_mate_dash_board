import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.cardTitle),
            const SizedBox(height: 6),
            Text(message, style: AppTextStyles.muted, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
