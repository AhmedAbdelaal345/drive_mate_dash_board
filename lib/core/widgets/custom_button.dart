import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : AppColors.navy;
    final background = isPrimary ? AppColors.navy : AppColors.surface;
    return SizedBox(
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.check, color: foreground),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          elevation: isPrimary ? 8 : 0,
          shadowColor: AppColors.navy.withValues(alpha: 0.18),
          backgroundColor: background,
          foregroundColor: foreground,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: isPrimary ? AppColors.navy : AppColors.border),
          ),
        ),
      ),
    );
  }
}
