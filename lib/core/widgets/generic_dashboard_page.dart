import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class GenericDashboardPage extends StatelessWidget {
  const GenericDashboardPage({
    super.key,
    required this.title,
    required this.selectedRoute,
    required this.adminType,
    this.child,
  });

  final String title;
  final String selectedRoute;
  final AdminType adminType;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: title,
      selectedRoute: selectedRoute,
      adminType: adminType,
      child:
          child ??
          Center(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
    );
  }
}
