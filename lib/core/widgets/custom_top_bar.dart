import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({super.key, required this.title, this.showBack = false});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              const SizedBox(width: 8),
              IconButton(
                tooltip: showBack ? 'Back' : 'Open navigation',
                onPressed: () {
                  if (showBack) {
                    Navigator.maybePop(context);
                    return;
                  }
                  Scaffold.maybeOf(context)?.openDrawer();
                },
                icon: Icon(showBack ? Icons.chevron_left : Icons.menu),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
