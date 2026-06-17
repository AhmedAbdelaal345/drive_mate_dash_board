import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_table.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/reports/manager/reports_cubit.dart';
import 'package:drive_mate_dash_board/features/reports/manager/reports_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsListPage extends StatefulWidget {
  const ReportsListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().loadReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Reports',
      selectedRoute: RouteNames.reports,
      adminType: widget.adminType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search reports by title, type or user...',
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
          BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoading) {
                return const LoadingWidget();
              } else if (state is ReportsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is ReportsSuccess) {
                final filteredReports = state.reports.where((report) {
                  return report.title.toLowerCase().contains(_searchQuery) ||
                      report.type.toLowerCase().contains(_searchQuery) ||
                      report.user.toLowerCase().contains(_searchQuery) ||
                      report.id.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredReports.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Reports Found',
                    message: 'Try adjusting your search criteria.',
                  );
                }

                return Column(
                  children: [
                    CustomTable(
                      columns: const [
                        'Report ID',
                        'Title',
                        'Report Type',
                        'Reporter',
                        'Priority',
                        'Status',
                        'Date'
                      ],
                      rows: filteredReports.map((report) {
                        final priorityColor =
                            report.priority.toLowerCase() == 'high'
                                ? Colors.red
                                : report.priority.toLowerCase() == 'medium'
                                ? Colors.orange
                                : Colors.blue;
                        return [
                          Text(
                            report.id,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(report.title),
                          Text(report.type),
                          Text(report.user),
                          StatusBadge(
                            label: report.priority,
                            color: priorityColor,
                          ),
                          StatusBadge(label: report.status),
                          Text(report.date),
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
