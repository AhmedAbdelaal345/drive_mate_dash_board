import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';
import 'package:drive_mate_dash_board/features/community/data/repo/community_repo.dart';
import 'package:drive_mate_dash_board/features/community/manager/community_cubit.dart';
import 'package:drive_mate_dash_board/features/community/manager/community_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityCubit(CommunityRepoImpl())..loadPosts(),
      child: _CommunityView(adminType: adminType),
    );
  }
}

// ── Internal view ──────────────────────────────────────────────────────────

class _CommunityView extends StatefulWidget {
  const _CommunityView({required this.adminType});

  final AdminType adminType;

  @override
  State<_CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<_CommunityView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Community',
      selectedRoute: RouteNames.community,
      adminType: widget.adminType,
      child: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          // Resolve filter and posts from any non-initial state
          final filter = switch (state) {
            CommunityLoaded(:final filter) => filter,
            CommunityActionLoading(:final filter) => filter,
            _ => CommunityFilter.all,
          };

          final posts = switch (state) {
            CommunityLoaded(:final posts) => posts,
            CommunityActionLoading(:final posts) => posts,
            _ => <CommunityPost>[],
          };

          final actionPostId = switch (state) {
            CommunityActionLoading(:final postId) => postId,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search + filter icon row
              Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                      hintText: 'Search by author, keywords...',
                      controller: _searchController,
                      onChanged: (v) =>
                          context.read<CommunityCubit>().search(v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _iconBtn(Icons.filter_list_rounded),
                ],
              ),
              const SizedBox(height: 14),

              // Filter tabs
              _FilterTabs(selected: filter),
              const SizedBox(height: 16),

              // Body
              if (state is CommunityLoading)
                const LoadingWidget()
              else if (state is CommunityError)
                _ErrorRetry(message: state.message)
              else if (posts.isEmpty)
                const EmptyStateWidget(
                  title: 'No Posts Found',
                  message:
                      'There are no posts matching the current filter.',
                )
              else
                ...posts.map(
                  (p) => _PostCard(
                    post: p,
                    isActionLoading: actionPostId == p.id,
                  ),
                ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
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
        onPressed: () {},
      ),
    );
  }
}

// ── Filter tabs ────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selected});

  final CommunityFilter selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: CommunityFilter.values.map((f) {
          final isSel = selected == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<CommunityCubit>().changeFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  f.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSel ? AppColors.text : AppColors.muted,
                    fontWeight:
                        isSel ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Post card ──────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.isActionLoading});

  final CommunityPost post;
  final bool isActionLoading;

  Color _categoryColor(PostCategory cat) => switch (cat) {
        PostCategory.question => Colors.blue.shade700,
        PostCategory.marketplace => Colors.purple.shade700,
        PostCategory.tip => Colors.green.shade700,
        PostCategory.discussion => Colors.teal.shade700,
        PostCategory.report => Colors.red.shade700,
        PostCategory.other => AppColors.muted,
      };

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (post.status) {
      PostStatus.active => 'ACTIVE',
      PostStatus.flagged => 'FLAGGED',
      PostStatus.deleted => 'DELETED',
    };

    final statusColor = switch (post.status) {
      PostStatus.active => AppColors.success,
      PostStatus.flagged => AppColors.warning,
      PostStatus.deleted => AppColors.danger,
    };

    final catColor = _categoryColor(post.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardSurface(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.softBlue,
                    child: Text(
                      post.author[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(label: statusLabel, color: statusColor),
                ],
              ),
              const SizedBox(height: 12),

              // Category chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: catColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  post.category.label,
                  style: TextStyle(
                    color: catColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Content
              Text(
                post.content,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.text,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              // Action row
              if (isActionLoading)
                const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                _ActionRow(post: post),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action row ─────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.post});

  final CommunityPost post;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommunityCubit>();

    return Row(
      children: [
        _Btn(
          icon: Icons.visibility_outlined,
          color: AppColors.primary,
          onTap: () => _showDetail(context),
        ),
        const SizedBox(width: 10),
        if (post.status != PostStatus.flagged)
          _Btn(
            icon: Icons.flag_outlined,
            color: Colors.orange.shade600,
            onTap: () => cubit.flagPost(post.id),
          ),
        if (post.status == PostStatus.flagged)
          _Btn(
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onTap: () => cubit.approvePost(post.id),
          ),
        const Spacer(),
        _Btn(
          icon: Icons.delete_outline_rounded,
          color: Colors.red.shade400,
          onTap: () => _confirmDelete(context, cubit),
        ),
      ],
    );
  }

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Post by ${post.author}'),
        content: Text(post.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CommunityCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text(
          'Are you sure you want to delete this post by ${post.author}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deletePost(post.id);
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

class _Btn extends StatelessWidget {
  const _Btn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 20),
      ),
    );
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
              onPressed: () => context.read<CommunityCubit>().loadPosts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}