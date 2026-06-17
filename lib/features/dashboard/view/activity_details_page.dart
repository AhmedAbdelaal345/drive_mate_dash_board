import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:flutter/material.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({
    super.key,
    required this.adminType,
    this.activity,
  });

  final AdminType adminType;
  final ActivityItemModel? activity;

  @override
  Widget build(BuildContext context) {
    // Standard mock fallback if no activity passed
    final item = activity ?? const ActivityItemModel(
      title: 'New car model added',
      subtitle: 'Toyota Camry 2024',
      actor: 'Admin User',
      time: '2 hours ago',
      type: 'Cars',
    );

    IconData getIcon(String type) {
      final t = type.toLowerCase();
      if (t == 'cars') return Icons.directions_car_filled_rounded;
      if (t == 'community') return Icons.forum_rounded;
      if (t == 'centers') return Icons.store_mall_directory_rounded;
      if (t == 'datasets') return Icons.storage_rounded;
      if (t == 'users') return Icons.supervised_user_circle_rounded;
      return Icons.info_rounded;
    }

    Color getColor(String type) {
      final t = type.toLowerCase();
      if (t == 'cars') return Colors.blue;
      if (t == 'community') return Colors.purple;
      if (t == 'centers') return Colors.orange;
      if (t == 'datasets') return Colors.green;
      if (t == 'users') return Colors.red;
      return Colors.grey;
    }

    final themeCol = getColor(item.type);

    return DashboardShell(
      title: 'Activity Detail',
      selectedRoute: '/activity-log',
      adminType: adminType,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner summary card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: themeCol.withValues(alpha: 0.1),
                  child: Icon(getIcon(item.type), color: themeCol, size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Operational Details Metadata Card
          const Text(
            'METADATA',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildMetadataRow('System Domain', item.type, Icons.dns_outlined),
                const Divider(height: 1),
                _buildMetadataRow('Operator / Actor', item.actor, Icons.person_outline_rounded),
                const Divider(height: 1),
                _buildMetadataRow('Timestamp', item.time, Icons.access_time_rounded),
                const Divider(height: 1),
                _buildMetadataRow('Status', 'Logged Success', Icons.check_circle_outline_rounded, iconColor: Colors.green),
                const Divider(height: 1),
                _buildMetadataRow('IP Address', '192.168.1.14', Icons.lan_outlined),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Parameter changeset diff table
          const Text(
            'PARAMETER CHANGESET',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.muted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),
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
                const Row(
                  children: [
                    Expanded(flex: 2, child: Text('Field', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted))),
                    Expanded(flex: 3, child: Text('Previous Value', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted))),
                    Expanded(flex: 3, child: Text('New Value', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted))),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _buildChangesetRow('Price / Charge', '\$26,500.00', '\$28,000.00'),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _buildChangesetRow('Status Flag', 'Draft', 'Published'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value, IconData icon, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? AppColors.muted),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
        ],
      ),
    );
  }

  Widget _buildChangesetRow(String field, String before, String after) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(field, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 13)),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.softRed,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(before, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(after, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
