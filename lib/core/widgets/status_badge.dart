import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? _colorFor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Color _colorFor(String label) {
    final value = label.toLowerCase();
    if (value.contains('published') || value.contains('active') || value.contains('operational')) {
      return AppColors.success;
    }
    if (value.contains('draft') || value.contains('pending')) return AppColors.warning;
    if (value.contains('closed') || value.contains('banned') || value.contains('delete')) {
      return AppColors.danger;
    }
    return AppColors.primary;
  }
}
