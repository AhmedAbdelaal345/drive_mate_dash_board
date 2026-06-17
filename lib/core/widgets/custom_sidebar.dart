import 'package:drive_mate_dash_board/core/constants/app_constants.dart';
import 'package:drive_mate_dash_board/core/routing/app_route_args.dart';
import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_cubit.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarDestination {
  const SidebarDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({
    super.key,
    required this.adminType,
    required this.selectedRoute,
    this.isPinned = false,
  });

  final AdminType adminType;
  final String selectedRoute;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    // Get email from AuthCubit state if logged in, otherwise default
    final authState = context.read<AuthCubit>().state;
    final String email = authState is AuthStateSuccessfully
        ? authState.email
        : adminType == AdminType.superAdmin
            ? AppConstants.superEmail
            : adminType == AdminType.opsAdmin
                ? AppConstants.opsEmail
                : AppConstants.communityEmail;

    final String displayName = adminType == AdminType.superAdmin
        ? 'Super Admin'
        : adminType == AdminType.opsAdmin
            ? 'Ops Manager'
            : 'Community Mod';

    final String initials = adminType == AdminType.superAdmin
        ? 'SA'
        : adminType == AdminType.opsAdmin
            ? 'OM'
            : 'CM';

    final groups = _getGroupedDestinations(adminType);

    return Drawer(
      width: 340,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar Header Profile Area
          Container(
            color: AppColors.navy,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_car_filled,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'DriveMate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    if (!isPinned)
                      IconButton(
                        tooltip: 'Close navigation',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                // Profile Section
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.teal, AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _RoleBadge(adminType: adminType),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grouped Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                if (groups.main.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 8, top: 4),
                    child: Text(
                      'MAIN NAVIGATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.muted,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ...groups.main.map((dest) => _buildItem(context, dest)),
                  const SizedBox(height: 16),
                ],
                if (groups.management.isNotEmpty) ...[
                  const Divider(height: 24, thickness: 1, color: AppColors.border),
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 8, top: 4),
                    child: Text(
                      'MANAGEMENT & CONTROL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.muted,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ...groups.management.map((dest) => _buildItem(context, dest)),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Logout Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.read<AuthCubit>().clear();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.login,
                  (_) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, SidebarDestination dest) {
    final isSelected = dest.route == selectedRoute;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? AppColors.teal : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (!isPinned) Navigator.pop(context);
            if (!isSelected) {
              Navigator.pushReplacementNamed(
                context,
                dest.route,
                arguments: AppRouteArgs(adminType: adminType),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  dest.icon,
                  color: isSelected ? Colors.white : AppColors.navy,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    dest.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _GroupedSidebarDestinations _getGroupedDestinations(AdminType adminType) {
    const dashboard = SidebarDestination(
      label: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: RouteNames.dashboard,
    );
    const cars = SidebarDestination(
      label: 'Manage Cars',
      icon: Icons.directions_car_rounded,
      route: RouteNames.cars,
    );
    const centers = SidebarDestination(
      label: 'Service Centers',
      icon: Icons.store_mall_directory_rounded,
      route: RouteNames.serviceCenters,
    );
    const analytics = SidebarDestination(
      label: 'Analytics',
      icon: Icons.analytics_rounded,
      route: RouteNames.analytics,
    );
    const community = SidebarDestination(
      label: 'Community',
      icon: Icons.forum_rounded,
      route: RouteNames.community,
    );
    const datasets = SidebarDestination(
      label: 'Datasets',
      icon: Icons.storage_rounded,
      route: RouteNames.datasets,
    );
    const users = SidebarDestination(
      label: 'Manage Users',
      icon: Icons.supervised_user_circle_rounded,
      route: RouteNames.users,
    );
    const tips = SidebarDestination(
      label: 'Manage Tips',
      icon: Icons.tips_and_updates_rounded,
      route: RouteNames.tips,
    );
    const admins = SidebarDestination(
      label: 'Admins',
      icon: Icons.admin_panel_settings_rounded,
      route: RouteNames.admins,
    );
    const reports = SidebarDestination(
      label: 'Reports',
      icon: Icons.report_problem_rounded,
      route: RouteNames.reports,
    );
    const settings = SidebarDestination(
      label: 'Settings',
      icon: Icons.settings_suggest_rounded,
      route: RouteNames.settings,
    );

    switch (adminType) {
      case AdminType.superAdmin:
        return _GroupedSidebarDestinations(
          main: [dashboard, cars, centers, analytics, community, datasets],
          management: [users, tips, admins, reports, settings],
        );
      case AdminType.opsAdmin:
        return _GroupedSidebarDestinations(
          main: [dashboard, cars, centers, analytics, datasets],
          management: [users, reports],
        );
      case AdminType.communityAdmin:
        return _GroupedSidebarDestinations(
          main: [dashboard, analytics, community],
          management: [users, tips],
        );
    }
  }
}

class _GroupedSidebarDestinations {
  const _GroupedSidebarDestinations({
    required this.main,
    required this.management,
  });

  final List<SidebarDestination> main;
  final List<SidebarDestination> management;
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    final colors = switch (adminType) {
      AdminType.superAdmin => (Colors.red.shade100, Colors.red.shade900),
      AdminType.opsAdmin => (Colors.blue.shade100, Colors.blue.shade900),
      AdminType.communityAdmin => (Colors.green.shade100, Colors.green.shade900),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        adminType.label.toUpperCase(),
        style: TextStyle(
          color: colors.$2,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
