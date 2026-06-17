import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/status_badge.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_cubit.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarsListPage extends StatefulWidget {
  const CarsListPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<CarsListPage> createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter parameters
  String _filterStatus = 'All';
  String _filterCondition = 'All';
  String _filterBrand = 'All';

  @override
  void initState() {
    super.initState();
    context.read<CarsCubit>().loadCars();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    String localStatus = _filterStatus;
    String localCondition = _filterCondition;
    String localBrand = _filterBrand;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Vehicles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Status Filter
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Published', 'Draft', 'Sold'].map((st) {
                      final isSel = localStatus == st;
                      return ChoiceChip(
                        label: Text(st),
                        selected: isSel,
                        onSelected: (_) => setModalState(() => localStatus = st),
                        selectedColor: AppColors.teal,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.text),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Condition Filter
                  const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'New', 'Used'].map((cond) {
                      final isSel = localCondition == cond;
                      return ChoiceChip(
                        label: Text(cond),
                        selected: isSel,
                        onSelected: (_) => setModalState(() => localCondition = cond),
                        selectedColor: AppColors.teal,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.text),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Brand Filter
                  const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Toyota', 'Honda', 'Ford', 'BMW'].map((br) {
                      final isSel = localBrand == br;
                      return ChoiceChip(
                        label: Text(br),
                        selected: isSel,
                        onSelected: (_) => setModalState(() => localBrand = br),
                        selectedColor: AppColors.teal,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.text),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setModalState(() {
                              localStatus = 'All';
                              localCondition = 'All';
                              localBrand = 'All';
                            });
                          },
                          child: const Text('Reset All', style: TextStyle(color: AppColors.muted)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          label: 'Apply Filters',
                          onPressed: () {
                            setState(() {
                              _filterStatus = localStatus;
                              _filterCondition = localCondition;
                              _filterBrand = localBrand;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Manage Cars',
      selectedRoute: RouteNames.cars,
      adminType: widget.adminType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  hintText: 'Search cars by brand, model or name...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: (_filterStatus != 'All' || _filterCondition != 'All' || _filterBrand != 'All')
                        ? AppColors.teal
                        : AppColors.muted,
                  ),
                  onPressed: _showFilterSheet,
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                label: 'Add Car',
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.addCar);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<CarsCubit, CarsState>(
            builder: (context, state) {
              if (state is CarsLoading) {
                return const LoadingWidget();
              } else if (state is CarsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (state is CarsSuccess) {
                final filteredCars = state.cars.where((car) {
                  final matchesSearch = car.name.toLowerCase().contains(_searchQuery) ||
                      car.brand.toLowerCase().contains(_searchQuery) ||
                      car.model.toLowerCase().contains(_searchQuery);

                  final matchesStatus = _filterStatus == 'All' || car.status.toLowerCase() == _filterStatus.toLowerCase();
                  final matchesCondition = _filterCondition == 'All' || car.condition.toLowerCase() == _filterCondition.toLowerCase();
                  final matchesBrand = _filterBrand == 'All' || car.brand.toLowerCase() == _filterBrand.toLowerCase();

                  return matchesSearch && matchesStatus && matchesCondition && matchesBrand;
                }).toList();

                if (filteredCars.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Vehicles Found',
                    message: 'Try adjusting your search query or filters.',
                  );
                }

                // Grid View of Cards
                final double screenWidth = MediaQuery.of(context).size.width;
                final int gridCount = screenWidth < 700 ? 1 : 2;

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 220,
                      ),
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        final car = filteredCars[index];
                        return _buildVehicleCard(car);
                      },
                    ),
                    const SizedBox(height: 24),
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

  Widget _buildVehicleCard(dynamic car) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Vehicle Image area / Colored Header
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.navy, AppColors.navy.withValues(alpha: 0.85)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car_filled, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        car.brand.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${car.year})',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  StatusBadge(label: car.status),
                ],
              ),
            ),
            // Info Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            car.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            car.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                car.price,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.teal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.softBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  car.condition,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.softBlue,
                            foregroundColor: AppColors.primary,
                          ),
                          icon: const Icon(Icons.edit_note_rounded, size: 22),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.editCar,
                              arguments: {'id': car.name},
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
