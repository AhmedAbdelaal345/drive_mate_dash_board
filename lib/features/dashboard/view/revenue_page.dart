import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  String _selectedRange = 'Month'; // 'Week', 'Month', 'Year'

  final Map<String, List<double>> _chartData = {
    'Week': [1200, 1800, 1500, 2200, 1900, 2400, 3100],
    'Month': [2400, 3100, 2900, 3800, 3500, 4200, 4800, 4100, 5200, 4900, 5800, 6200],
    'Year': [28000, 32000, 35000, 42300],
  };

  final Map<String, List<String>> _chartLabels = {
    'Week': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'Year': ['2023', '2024', '2025', '2026'],
  };

  @override
  Widget build(BuildContext context) {
    final rawData = _chartData[_selectedRange]!;
    final labels = _chartLabels[_selectedRange]!;
    final double maxVal = rawData.reduce((curr, next) => curr > next ? curr : next);

    return DashboardShell(
      title: 'Revenue Analytics',
      selectedRoute: '/revenue',
      adminType: widget.adminType,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Revenue Display
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL REVENUE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.trending_up, color: Colors.green.shade400, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '+18.2%',
                            style: TextStyle(
                              color: Colors.green.shade400,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '\$42,300.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Calculated based on subscriptions & vehicle listing options',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Chart Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Earnings Trend',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                    ),
                    // Segmented Range Selector
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: ['Week', 'Month', 'Year'].map((range) {
                          final isSel = _selectedRange == range;
                          return InkWell(
                            onTap: () => setState(() => _selectedRange = range),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSel ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                range,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  color: isSel ? AppColors.text : AppColors.muted,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Chart Bars representation
                SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(rawData.length, (idx) {
                      final val = rawData[idx];
                      final pct = maxVal > 0 ? (val / maxVal) : 0.0;
                      return Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              idx % 2 == 0 || rawData.length < 8 ? '\$${(val / 1000).toStringAsFixed(1)}k' : '',
                              style: const TextStyle(fontSize: 9, color: AppColors.muted),
                            ),
                            const SizedBox(height: 4),
                            FractionallySizedBox(
                              heightFactor: pct.clamp(0.08, 1.0),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.teal,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              labels[idx],
                              style: const TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Revenue breakdown by stream progress indicators
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Revenue by Source',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                ),
                const SizedBox(height: 20),
                _buildSourceItem('Car Listing Packages', 25380, 0.60, Colors.blue),
                const SizedBox(height: 16),
                _buildSourceItem('Featured Advertisements', 12300, 0.29, Colors.teal),
                const SizedBox(height: 16),
                _buildSourceItem('Service Center Leads', 4620, 0.11, Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Transaction log
          const Text(
            'RECENT TRANSACTIONS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          _buildTransactionList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String name, double amount, double percent, Color col) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
            ),
            Text(
              '\$${amount.toStringAsFixed(0)} (${(percent * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: percent,
            color: col,
            backgroundColor: AppColors.background,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final List<Map<String, dynamic>> txns = [
      {'id': '#TXN-9821', 'user': 'Sara Mahmoud', 'date': '2 hours ago', 'amount': '\$120.00', 'source': 'Featured Ad', 'status': 'Success'},
      {'id': '#TXN-9820', 'user': 'Ali Fahad', 'date': '5 hours ago', 'amount': '\$45.00', 'source': 'Listing Upgrade', 'status': 'Success'},
      {'id': '#TXN-9819', 'user': 'Sharjah Workshop', 'date': 'Yesterday', 'amount': '\$350.00', 'source': 'Lead Bundle', 'status': 'Success'},
      {'id': '#TXN-9818', 'user': 'Khalid Al-Sayed', 'date': '2 days ago', 'amount': '\$120.00', 'source': 'Featured Ad', 'status': 'Success'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: txns.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, idx) {
          final item = txns[idx];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: AppColors.softGreen,
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
                Text(item['amount'] as String, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.teal)),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item['user']} • ${item['source']}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  Text(item['date'] as String, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
