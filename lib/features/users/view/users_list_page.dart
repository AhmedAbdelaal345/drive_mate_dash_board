import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_table.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_cubit.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().loadUsers();
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search users by name, email or phone...',
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
          BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return const LoadingWidget();
              } else if (state is UsersError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is UsersSuccess) {
                final filteredUsers = state.users.where((user) {
                  return user.name.toLowerCase().contains(_searchQuery) ||
                      user.email.toLowerCase().contains(_searchQuery) ||
                      user.phone.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Users Found',
                    message: 'Try adjusting your search criteria.',
                  );
                }

                return Column(
                  children: [
                    CustomTable(
                      columns: const [
                        'User Name',
                        'Email Address',
                        'Phone Number',
                        'Role',
                        'Status',
                        'Joined Date',
                        'Cars Count'
                      ],
                      rows: filteredUsers.map((user) {
                        return [
                          Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(user.email),
                          Text(user.phone),
                          Text(user.role),
                          StatusBadge(label: user.status),
                          Text(user.joinedDate),
                          Text('${user.carsCount}'),
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
