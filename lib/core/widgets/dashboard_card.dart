import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.delta,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.softBlue,
    this.onTap,
    this.dark = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final String? delta;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final cardColor = dark ? AppColors.navy : AppColors.surface;
    final textColor = dark ? Colors.white : AppColors.text;
    final mutedColor = dark ? Colors.white70 : AppColors.muted;
    return CardSurface(
      onTap: onTap,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: dark ? Colors.white.withValues(alpha: 0.12) : iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: dark ? Colors.white : iconColor),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.muted.copyWith(color: mutedColor),
                  ),
                ),
                if (delta != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      delta!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: AppTextStyles.muted),
            ],
          ],
        ),
      ),
    );
  }
}

class CardSurface extends StatelessWidget {
  const CardSurface({
    super.key,
    required this.child,
    this.onTap,
    this.color = AppColors.surface,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}
