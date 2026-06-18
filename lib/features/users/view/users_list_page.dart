import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';
import 'package:drive_mate_dash_board/features/users/data/users_repo.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_cubit.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit(UsersRepoImpl())..loadUsers(),
      child: _ManageUsersView(adminType: adminType),
    );
  }
}

// ── Internal view ──────────────────────────────────────────────────────────

class _ManageUsersView extends StatefulWidget {
  const _ManageUsersView({required this.adminType});

  final AdminType adminType;

  @override
  State<_ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<_ManageUsersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Manage Users',
      selectedRoute: RouteNames.users,
      adminType: widget.adminType,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          // Resolve shared fields across loaded / action-loading states
          final users = switch (state) {
            UsersLoaded(:final users) => users,
            UsersActionLoading(:final users) => users,
            _ => <AppUser>[],
          };

          final stats = switch (state) {
            UsersLoaded(:final stats) => stats,
            UsersActionLoading(:final stats) => stats,
            _ => null,
          };

          final page = switch (state) {
            UsersLoaded(:final page) => page,
            UsersActionLoading(:final page) => page,
            _ => 1,
          };

          final actionUserId = switch (state) {
            UsersActionLoading(:final userId) => userId,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search + action icons
              Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                      hintText: 'Search users...',
                      controller: _searchController,
                      onChanged: (v) =>
                          context.read<UsersCubit>().search(v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconBtn(
                    icon: Icons.filter_list_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _IconBtn(
                    icon: Icons.download_rounded,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats row — always show if available
              if (stats != null) ...[
                _StatsRow(stats: stats),
                const SizedBox(height: 20),
              ],

              // Body
              if (state is UsersLoading)
                const LoadingWidget()
              else if (state is UsersError)
                _ErrorRetry(message: state.message)
              else if (users.isEmpty)
                const EmptyStateWidget(
                  title: 'No Users Found',
                  message: 'No users match your search query.',
                )
              else
                ...users.map(
                  (u) => _UserCard(
                    user: u,
                    isActionLoading: actionUserId == u.id,
                  ),
                ),

              const SizedBox(height: 8),
              CustomPagination(currentPage: page),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

// ── Icon button ────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.muted, size: 20),
        onPressed: onTap,
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final UsersStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'TOTAL USERS', value: '${stats.total}', dark: true),
        const SizedBox(width: 12),
        _StatCard(
          label: 'ACTIVE',
          value: '${stats.active}',
          valueColor: AppColors.success,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'BANNED',
          value: '${stats.banned}',
          valueColor: AppColors.danger,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.dark = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool dark;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: dark ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dark ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white60 : AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: dark
                    ? Colors.white
                    : (valueColor ?? AppColors.text),
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── User card ──────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.isActionLoading});

  final AppUser user;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    final statusBadge = switch (user.status) {
      UserStatus.active => null,
      UserStatus.suspended => (
          'SUSPENDED',
          AppColors.warning,
        ),
      UserStatus.banned => ('BANNED', AppColors.danger),
    };

    final roleColor = switch (user.role) {
      UserRole.user => AppColors.muted,
      UserRole.centerAdmin => Colors.purple.shade700,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CardSurface(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.softBlue,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                            if (statusBadge != null)
                              StatusBadge(
                                label: statusBadge.$1,
                                color: statusBadge.$2,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.mail_outline_rounded,
                              size: 12,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                user.email,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3-dot menu or loading spinner
                  if (isActionLoading)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.muted,
                        size: 20,
                      ),
                      onSelected: (value) =>
                          _handleMenuAction(context, cubit, value),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('View Profile'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: user.status == UserStatus.banned
                              ? 'unban'
                              : 'ban',
                          child: Row(
                            children: [
                              Icon(
                                user.status == UserStatus.banned
                                    ? Icons.check_circle_outline
                                    : Icons.block_rounded,
                                size: 16,
                                color: user.status == UserStatus.banned
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user.status == UserStatus.banned
                                    ? 'Unban User'
                                    : 'Ban User',
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('Delete User'),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Meta row
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.joinDate,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.directions_car_outlined,
                    size: 13,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.carsCount} Cars',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    user.role.label,
                    style: TextStyle(
                      color: roleColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    UsersCubit cubit,
    String action,
  ) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing ${user.name}\'s profile...')),
        );

      case 'ban':
        cubit.banUser(user.id);

      case 'unban':
        cubit.unbanUser(user.id);

      case 'delete':
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete User'),
            content: Text(
              'Are you sure you want to permanently delete ${user.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.deleteUser(user.id);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ),
            ],
          ),
        );
    }
  }
}

// ── Error + retry ──────────────────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 44),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<UsersCubit>().loadUsers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}