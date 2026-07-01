import 'package:drive_mate_dash_board/core/routing/app_route_args.dart';
import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_cubit.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_state.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/manager/dashboard_cubit.dart';
import 'package:drive_mate_dash_board/features/dashboard/manager/dashboard_state.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_metric_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardCubit>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    if (authState is! AuthStateSuccessfully) {
      // Not authenticated - redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final adminType = authState.type;

    return DashboardShell(
      title: 'Dashboard',
      selectedRoute: RouteNames.dashboard,
      adminType: adminType,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final metrics = state is DashboardSuccess ? state.metrics : <DashboardMetricModel>[];
          final activities = state is DashboardSuccess ? state.activities : <ActivityItemModel>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // GREETING BANNER
              _buildWelcomeBanner(adminType),
              const SizedBox(height: 24),

              // SYSTEM PERFORMANCE OR LOADING
              if (state is DashboardLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // METRICS GRID (Responsive)
                const Text(
                  'SYSTEM PERFORMANCE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.muted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMetricsGrid(adminType, metrics),
                const SizedBox(height: 28),
              ],

              // QUICK ACTIONS
              const Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(adminType),
              const SizedBox(height: 28),

              // RECENT ACTIVITY LOG
              if (state is! DashboardLoading) ...[
                const Text(
                  'RECENT SYSTEM ACTIVITY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.muted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecentActivitySection(adminType, activities),
                const SizedBox(height: 24),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeBanner(AdminType adminType) {
    final displayName = adminType == AdminType.superAdmin
        ? 'Super Admin'
        : adminType == AdminType.opsAdmin
            ? 'Ops Manager'
            : 'Community Mod';

    final subtitle = adminType == AdminType.superAdmin
        ? 'Here is your system-wide performance and management overview.'
        : adminType == AdminType.opsAdmin
            ? 'Monitor vehicles, service centers, and system diagnostics.'
            : 'Moderate user reports, tips, and community interaction.';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Welcome back, $displayName 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(AdminType adminType, List<DashboardMetricModel> stats) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 700 ? 2 : 4;
    final double aspectRatio = screenWidth < 700 ? 1.35 : 1.45;

    String getValueFor(String title, String defaultValue) {
      if (stats.isEmpty) return defaultValue;
      final match = stats.firstWhere(
        (e) => e.title.toLowerCase().trim() == title.toLowerCase().trim(),
        orElse: () => DashboardMetricModel(title: title, value: defaultValue, delta: '', iconName: ''),
      );
      return match.value;
    }

    final carsCard = DashboardCard(
      title: 'Total Cars',
      value: getValueFor('Total Cars', '432'),
      icon: Icons.directions_car_rounded,
      delta: '+5%',
      iconColor: Colors.blue.shade700,
      iconBackground: AppColors.softBlue,
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.totalCars,
        arguments: AppRouteArgs(adminType: adminType),
      ),
    );

    final usersCard = DashboardCard(
      title: 'Active Users',
      value: getValueFor('Active Users', '1,234'),
      icon: Icons.people_alt_rounded,
      delta: '+12%',
      iconColor: Colors.teal.shade700,
      iconBackground: AppColors.softCyan,
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.activeUsers,
        arguments: AppRouteArgs(adminType: adminType),
      ),
    );

    final revenueCard = DashboardCard(
      title: 'Revenue',
      value: getValueFor('Revenue', r'$45k'),
      icon: Icons.monetization_on_rounded,
      delta: '+18%',
      iconColor: Colors.green.shade700,
      iconBackground: AppColors.softGreen,
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.revenue,
        arguments: AppRouteArgs(adminType: adminType),
      ),
    );

    final reviewsCard = DashboardCard(
      title: 'Pending Reviews',
      value: getValueFor('Pending Reviews', '12'),
      icon: Icons.pending_actions_rounded,
      delta: '-2%',
      iconColor: Colors.amber.shade800,
      iconBackground: AppColors.softOrange,
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.pendingReviews,
        arguments: AppRouteArgs(adminType: adminType),
      ),
    );

    // Show/hide based on roles
    final List<Widget> cards = [];
    if (adminType == AdminType.superAdmin) {
      cards.addAll([usersCard, carsCard, revenueCard, reviewsCard]);
    } else if (adminType == AdminType.opsAdmin) {
      cards.addAll([carsCard, reviewsCard, usersCard, revenueCard]);
    } else {
      // communityAdmin
      cards.addAll([usersCard, reviewsCard]);
    }

    final displayCrossAxisCount = cards.length < crossAxisCount ? cards.length : crossAxisCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: displayCrossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _buildQuickActions(AdminType adminType) {
    final List<Widget> actions = [];

    void push(String route) {
      Navigator.pushReplacementNamed(
        context,
        route,
        arguments: AppRouteArgs(adminType: adminType),
      );
    }

    void navigate(String route) {
      Navigator.pushNamed(
        context,
        route,
        arguments: AppRouteArgs(adminType: adminType),
      );
    }

    if (adminType == AdminType.superAdmin) {
      actions.addAll([
        _QuickActionTile(
          icon: Icons.supervised_user_circle_rounded,
          label: 'Manage Users',
          color: Colors.teal,
          onTap: () => push(RouteNames.users),
        ),
        _QuickActionTile(
          icon: Icons.admin_panel_settings_rounded,
          label: 'System Admins',
          color: Colors.red,
          onTap: () => push(RouteNames.admins),
        ),
        _QuickActionTile(
          icon: Icons.storage_rounded,
          label: 'Manage Datasets',
          color: Colors.blue,
          onTap: () => push(RouteNames.datasets),
        ),
        _QuickActionTile(
          icon: Icons.settings_rounded,
          label: 'App Settings',
          color: Colors.grey.shade700,
          onTap: () => push(RouteNames.settings),
        ),
      ]);
    } else if (adminType == AdminType.opsAdmin) {
      actions.addAll([
        _QuickActionTile(
          icon: Icons.add_to_photos_rounded,
          label: 'Register New Car',
          color: Colors.blue,
          onTap: () => navigate(RouteNames.addCar),
        ),
        _QuickActionTile(
          icon: Icons.store_mall_directory_rounded,
          label: 'Service Centers',
          color: Colors.teal,
          onTap: () => push(RouteNames.serviceCenters),
        ),
        _QuickActionTile(
          icon: Icons.report_gmailerrorred_rounded,
          label: 'View Flagged Reports',
          color: Colors.amber,
          onTap: () => push(RouteNames.reports),
        ),
      ]);
    } else if (adminType == AdminType.communityAdmin) {
      actions.addAll([
        _QuickActionTile(
          icon: Icons.tips_and_updates_rounded,
          label: 'Create A Driver Tip',
          color: Colors.green,
          onTap: () => navigate(RouteNames.addTip),
        ),
        _QuickActionTile(
          icon: Icons.topic_rounded,
          label: 'Manage Tips List',
          color: Colors.teal,
          onTap: () => push(RouteNames.tips),
        ),
        _QuickActionTile(
          icon: Icons.supervised_user_circle_rounded,
          label: 'Manage Users',
          color: Colors.blue,
          onTap: () => push(RouteNames.users),
        ),
      ]);
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions,
    );
  }

  Widget _buildRecentActivitySection(
      AdminType adminType, List<ActivityItemModel> apiActivities) {
    // Show top 4 activities from API (or MockData if empty)
    final activities = apiActivities.isEmpty
        ? MockData.activities.take(4).toList()
        : apiActivities.take(4).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Operations Log',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.activityLog,
                      arguments: AppRouteArgs(adminType: adminType),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Full Log',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final act = activities[index];
              return _buildActivityItem(act);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(dynamic act) {
    IconData getIcon(String type, String title) {
      final t = type.toLowerCase();
      final lowerTitle = title.toLowerCase();
      if (t == 'cars') {
        return lowerTitle.contains('price') ? Icons.edit_road_rounded : Icons.add_circle_outline_rounded;
      }
      if (t == 'community') return Icons.shield_outlined;
      if (t == 'centers') return Icons.location_on_outlined;
      if (t == 'datasets') return Icons.dataset_rounded;
      if (t == 'users') return Icons.person_remove_rounded;
      return Icons.info_outline_rounded;
    }

    Color getColor(String type) {
      final t = type.toLowerCase();
      if (t == 'cars') return Colors.blue;
      if (t == 'community') return Colors.purple;
      if (t == 'centers') return Colors.orange;
      if (t == 'datasets') return Colors.green;
      if (t == 'users') return Colors.red;
      return Colors.grey;
    }

    final col = getColor(act.type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: col.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(act.type, act.title),
              color: col,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${act.subtitle} • by ${act.actor}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            act.time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
