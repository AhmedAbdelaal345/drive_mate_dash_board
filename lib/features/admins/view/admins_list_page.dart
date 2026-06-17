import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_table.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/admins/manager/admins_cubit.dart';
import 'package:drive_mate_dash_board/features/admins/manager/admins_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminsListPage extends StatefulWidget {
  const AdminsListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<AdminsListPage> createState() => _AdminsListPageState();
}

class _AdminsListPageState extends State<AdminsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminsCubit>().loadAdmins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Admins',
      selectedRoute: RouteNames.admins,
      adminType: widget.adminType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search admins by name or email...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<AdminsCubit, AdminsState>(
            builder: (context, state) {
              if (state is AdminsLoading) {
                return const LoadingWidget();
              } else if (state is AdminsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is AdminsSuccess) {
                final filteredAdmins = state.admins.where((admin) {
                  return admin.name.toLowerCase().contains(_searchQuery) ||
                      admin.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredAdmins.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Admins Found',
                    message: 'Try adjusting your search criteria.',
                  );
                }

                return Column(
                  children: [
                    CustomTable(
                      columns: const [
                        'Admin Name',
                        'Email Address',
                        'Role / Permission',
                        'Status'
                      ],
                      rows: filteredAdmins.map((admin) {
                        return [
                          Text(
                            admin.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(admin.email),
                          Text(admin.role.label),
                          StatusBadge(label: admin.status),
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
}
