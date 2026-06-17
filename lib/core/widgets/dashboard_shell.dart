import 'package:drive_mate_dash_board/core/widgets/custom_sidebar.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_top_bar.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.title,
    required this.selectedRoute,
    required this.adminType,
    required this.child,
    this.showBack = false,
    this.maxContentWidth = 680,
  });

  final String title;
  final String selectedRoute;
  final AdminType adminType;
  final Widget child;
  final bool showBack;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showPinnedSidebar = constraints.maxWidth >= 1280 && !showBack;
        return Scaffold(
          drawer: showPinnedSidebar
              ? null
              : CustomSidebar(
                  adminType: adminType,
                  selectedRoute: selectedRoute,
                ),
          body: Row(
            children: [
              if (showPinnedSidebar)
                SizedBox(
                  width: 360,
                  child: CustomSidebar(
                    adminType: adminType,
                    selectedRoute: selectedRoute,
                    isPinned: true,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    CustomTopBar(title: title, showBack: showBack),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxContentWidth,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
