import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_table.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/tips/data/tips_repo.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_cubit.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TipsListPage extends StatelessWidget {
  const TipsListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TipsCubit(TipsRepoImpl())..loadTips(),
      child: _TipsListView(adminType: adminType),
    );
  }
}

class _TipsListView extends StatefulWidget {
  const _TipsListView({required this.adminType});

  final AdminType adminType;

  @override
  State<_TipsListView> createState() => _TipsListViewState();
}

class _TipsListViewState extends State<_TipsListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Manage Tips',
      selectedRoute: RouteNames.tips,
      adminType: widget.adminType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search tips by title or category...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              CustomButton(
                label: 'Add Tip',
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.addTip);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<TipsCubit, TipsState>(
            builder: (context, state) {
              if (state is TipsLoading) {
                return const LoadingWidget();
              } else if (state is TipsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is TipsSuccess) {
                final filtered = state.tips.where((tip) {
                  return tip.title.toLowerCase().contains(_searchQuery) ||
                      (tip.category ?? 'Tip').toLowerCase().contains(
                        _searchQuery,
                      );
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Tips Found',
                    message: 'Try adjusting your search criteria.',
                  );
                }

                return Column(
                  children: [
                    CustomTable(
                      columns: const [
                        'Tip Title',
                        'Category',
                        'Difficulty',
                        'Duration',
                        'Views',
                        'Likes',
                        'Status',
                        'Actions',
                      ],
                      rows: filtered.map((tip) {
                        return [
                          Text(
                            tip.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(tip.category ?? "Tip"),
                          Text(tip.content),
                          Text(tip.createdAt.toString()),
                          Text('${tip.authorName}'),
                          Text('${tip.isPublished}'),
                          StatusBadge(label: tip.isPublished.toString()),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.editTip,
                                    arguments: {'id': tip.id},
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _confirmDelete(context, tip.id),
                              ),
                            ],
                          ),
                        ];
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const CustomPagination(currentPage: 1),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    final cubit = context.read<TipsCubit>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Tip'),
        content: const Text('Are you sure you want to delete this tip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              //TODO: cubit.deleteTip(id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade600)),
          ),
        ],
      ),
    );
  }
}
