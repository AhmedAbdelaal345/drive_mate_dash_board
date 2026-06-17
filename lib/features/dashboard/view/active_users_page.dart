import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class ActiveUsersPage extends StatefulWidget {
  const ActiveUsersPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<ActiveUsersPage> createState() => _ActiveUsersPageState();
}

class _ActiveUsersPageState extends State<ActiveUsersPage> {
  String _selectedPeriod = '7d'; // 'Today', '7d', '30d'

  // Mock data for the different periods
  final Map<String, Map<String, dynamic>> _data = {
    'Today': {
      'value': '1,234',
      'delta': '+12% vs today',
      'bars': [45, 60, 50, 75, 65, 80, 55],
      'breakdown': [
        {'date': 'Today', 'users': '1,234', 'delta': '+12', 'isPos': true},
        {'date': '1 hour ago', 'users': '1,150', 'delta': '+30', 'isPos': true},
        {'date': '2 hours ago', 'users': '1,120', 'delta': '-15', 'isPos': false},
        {'date': '3 hours ago', 'users': '1,135', 'delta': '+8', 'isPos': true},
      ]
    },
    '7d': {
      'value': '1,234',
      'delta': '+12% vs last 7d',
      'bars': [45, 65, 60, 75, 65, 85, 78],
      'breakdown': [
        {'date': 'Today', 'users': '1,234', 'delta': '+12', 'isPos': true},
        {'date': 'Yesterday', 'users': '1,222', 'delta': '+45', 'isPos': true},
        {'date': 'Mon, Feb 8', 'users': '1,177', 'delta': '-5', 'isPos': false},
        {'date': 'Sun, Feb 7', 'users': '1,182', 'delta': '+10', 'isPos': true},
      ]
    },
    '30d': {
      'value': '1,234',
      'delta': '+12% vs last 30d',
      'bars': [40, 55, 52, 60, 58, 68, 62, 70, 75, 65, 80, 72, 78],
      'breakdown': [
        {'date': 'This Week', 'users': '8,420', 'delta': '+8%', 'isPos': true},
        {'date': 'Last Week', 'users': '7,800', 'delta': '+14%', 'isPos': true},
        {'date': '2 Weeks Ago', 'users': '6,842', 'delta': '-3%', 'isPos': false},
        {'date': '3 Weeks Ago', 'users': '7,053', 'delta': '+12%', 'isPos': true},
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final periodData = _data[_selectedPeriod]!;
    final bars = periodData['bars'] as List<int>;
    final breakdown = periodData['breakdown'] as List<Map<String, dynamic>>;

    return DashboardShell(
      title: 'Active Users',
      selectedRoute: '/active-users',
      adminType: widget.adminType,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stat Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.softBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    // Segmented Control
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: ['Today', '7d', '30d'].map((period) {
                          final isSel = _selectedPeriod == period;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedPeriod = period;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSel ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: isSel
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                period,
                                style: TextStyle(
                                  color: isSel ? AppColors.text : AppColors.muted,
                                  fontWeight:
                                      isSel ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  periodData['value'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Active Users',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.green,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            periodData['delta'],
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Bar Chart Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: bars.map((val) {
                      return Flexible(
                        child: FractionallySizedBox(
                          heightFactor: val / 100.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade300,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'User activity trend ($_selectedPeriod)',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Daily Breakdown Title
          const Text(
            'DAILY BREAKDOWN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.8,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          // Breakdown List
          Column(
            children: breakdown.map((item) {
              final isPos = item['isPos'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['date'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['users'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          item['delta'],
                          style: TextStyle(
                            color: isPos ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
