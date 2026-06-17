import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomPagination extends StatelessWidget {
  const CustomPagination({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Previous page',
          onPressed: () {
            // TODO: Implement API Integration
          },
          icon: const Icon(Icons.chevron_left),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.softCyan,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('$currentPage'),
        ),
        IconButton(
          tooltip: 'Next page',
          onPressed: () {
            // TODO: Implement API Integration
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
