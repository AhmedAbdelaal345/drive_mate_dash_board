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
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_cubit.dart';
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CentersListPage extends StatefulWidget {
  const CentersListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<CentersListPage> createState() => _CentersListPageState();
}

class _CentersListPageState extends State<CentersListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ServiceCentersCubit>().loadCenters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Service Centers',
      selectedRoute: RouteNames.serviceCenters,
      adminType: widget.adminType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search centers by name or city...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                    context
                        .read<ServiceCentersCubit>()
                        .loadCenters(searchTerm: value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              CustomButton(
                label: 'Add Center',
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.addCenter);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<ServiceCentersCubit, ServiceCentersState>(
            builder: (context, state) {
              if (state is ServiceCentersLoading) {
                return const LoadingWidget();
              } else if (state is ServiceCentersError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is ServiceCentersSuccess) {
                final filtered = state.centers.where((center) {
                  return center.name.toLowerCase().contains(_searchQuery) ||
                      center.city.toLowerCase().contains(_searchQuery) ||
                      center.location.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Service Centers Found',
                    message: 'Try adjusting your search query.',
                  );
                }

                return Column(
                  children: [
                    CustomTable(
                      columns: const [
                        'Center Name',
                        'City',
                        'Address / Location',
                        'Phone Number',
                        'Services Provided',
                        'Status',
                        'Actions'
                      ],
                      rows: filtered.map((center) {
                        return [
                          Text(
                            center.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(center.city),
                          Text(center.location),
                          Text(center.phone),
                          Text(center.services),
                          StatusBadge(label: center.status),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.editCenter,
                                    arguments: {'id': center.name},
                                  );
                                },
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
}
