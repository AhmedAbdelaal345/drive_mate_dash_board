import 'package:drive_mate_dash_board/core/theme/app_text_styles.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CardSurface(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.cardTitle),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
    );
  }
}
