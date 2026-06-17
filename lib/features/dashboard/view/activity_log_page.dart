import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';
import 'package:flutter/material.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilterType = 'All';

  List<ActivityItemModel> get _filteredActivities {
    return MockData.activities.where((act) {
      final matchesSearch =
          act.title.toLowerCase().contains(_searchQuery) ||
          act.subtitle.toLowerCase().contains(_searchQuery) ||
          act.actor.toLowerCase().contains(_searchQuery);

      if (_selectedFilterType == 'All') {
        return matchesSearch;
      } else {
        return matchesSearch &&
            act.type.toLowerCase() == _selectedFilterType.toLowerCase();
      }
    }).toList();
  }

  void _showFilterBottomSheet() {
    String localSelected = _selectedFilterType;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Activity',
                        style: TextStyle(
                          fontSize: 20,
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
                  const Text(
                    'Activity Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'All',
                          'Cars',
                          'Centers',
                          'Community',
                          'Datasets',
                          'Users',
                        ].map((type) {
                          final isSel = localSelected == type;
                          return ChoiceChip(
                            label: Text(type),
                            selected: isSel,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  localSelected = type;
                                });
                              }
                            },
                            selectedColor: AppColors.navy,
                            backgroundColor: AppColors.softBlue,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppColors.text,
                              fontWeight: isSel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: AppColors.text,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              localSelected = 'All';
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedFilterType = localSelected;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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

  IconData _iconForType(String type, String title) {
    final t = type.toLowerCase();
    final lowerTitle = title.toLowerCase();
    if (t == 'cars') {
      if (lowerTitle.contains('price')) return Icons.edit;
      return Icons.add;
    }
    if (t == 'community') return Icons.shield_outlined;
    if (t == 'centers') return Icons.location_on_outlined;
    if (t == 'datasets') return Icons.dataset;
    if (t == 'users') return Icons.person_remove_outlined;
    return Icons.notifications_none;
  }

  Color _colorForType(String type, String title) {
    final t = type.toLowerCase();
    if (t == 'cars') return Colors.blue;
    if (t == 'community') return Colors.purple;
    if (t == 'centers') return Colors.orange;
    if (t == 'datasets') return Colors.green;
    if (t == 'users') return Colors.purple;
    return Colors.grey;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredActivities;

    return DashboardShell(
      title: 'Activity Log',
      selectedRoute: '/activity-log',
      adminType: widget.adminType,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search & Filter Icon
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search activity...',
                    prefixIcon: Icon(Icons.search, color: AppColors.muted),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surface,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.muted,
                  ),
                  onPressed: _showFilterBottomSheet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Filter Chips Horizontal Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'All',
                    'Cars',
                    'Centers',
                    'Community',
                    'Datasets',
                    'Users',
                  ].map((type) {
                    final isSel = _selectedFilterType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSel,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilterType = type;
                            });
                          }
                        },
                        selectedColor: AppColors.teal,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.text,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSel ? AppColors.teal : AppColors.border,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Activity list
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No activities match your query.'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final act = filtered[index];
                final col = _colorForType(act.type, act.title);
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon circle
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: col.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconForType(act.type, act.title),
                            color: col,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Middle Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                act.subtitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.muted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'by ${act.actor}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Time
                        Text(
                          act.time,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
