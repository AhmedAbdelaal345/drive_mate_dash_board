import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_button.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';

class PendingReviewsPage extends StatefulWidget {
  const PendingReviewsPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  State<PendingReviewsPage> createState() => _PendingReviewsPageState();
}

class _PendingReviewsPageState extends State<PendingReviewsPage> {
  // Mock data for reviews that can be manipulated locally
  final List<Map<String, dynamic>> _reviews = [
    {
      'id': 'REV-101',
      'type': 'Car Listing',
      'title': 'Nissan Patrol 2021 approval request',
      'user': 'seller_dxb',
      'time': '30 mins ago',
      'priority': 'Medium',
      'details': 'Brand new seller requesting verification for a Nissan Patrol listed at \$42,000. VIN matches specs.'
    },
    {
      'id': 'REV-102',
      'type': 'Flagged Post',
      'title': 'Suspicious external link in comment',
      'user': 'driver_99',
      'time': '2 hours ago',
      'priority': 'High',
      'details': 'User reported a post containing links redirecting to off-platform payment schemes.'
    },
    {
      'id': 'REV-103',
      'type': 'Center Report',
      'title': 'Sharjah workshop service mismatch',
      'user': 'complainer_1',
      'time': '5 hours ago',
      'priority': 'Low',
      'details': 'Customer reported that the workshop did not honor the listed tire alignment discount package.'
    },
    {
      'id': 'REV-104',
      'type': 'Profile Verification',
      'title': 'Corporate fleet account request',
      'user': 'al_futtaim_rentals',
      'time': 'Yesterday',
      'priority': 'High',
      'details': 'Commercial rental agency requesting bulk account permissions to list 25+ vehicles.'
    },
  ];

  void _removeItem(String id, String actionType) {
    setState(() {
      _reviews.removeWhere((r) => r['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item $id has been $actionType.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Pending Reviews',
      selectedRoute: '/pending-reviews',
      adminType: widget.adminType,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.softOrange,
                  child: const Icon(Icons.pending_actions_rounded, color: AppColors.warning),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Operational Backlog',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_reviews.length} items require administrator review or authorization.',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Review list
          if (_reviews.isEmpty)
            const EmptyStateWidget(
              title: 'All Caught Up! 🎉',
              message: 'No pending items remain in the moderation backlog.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final item = _reviews[idx];
                return _buildReviewCard(item);
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> item) {
    final priority = item['priority'] as String;
    final priorityCol = priority == 'High'
        ? Colors.red
        : priority == 'Medium'
            ? Colors.orange
            : Colors.blue;

    final priorityBg = priority == 'High'
        ? AppColors.softRed
        : priority == 'Medium'
            ? AppColors.softOrange
            : AppColors.softBlue;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (item['type'] as String).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['id'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priorityBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(color: priorityCol, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Card Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  'Submitted by: ${item['user']} • ${item['time']}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Text(
                  item['details'] as String,
                  style: const TextStyle(color: AppColors.text, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Action Buttons Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _removeItem(item['id'] as String, 'Dismissed'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.muted),
                  child: const Text('Dismiss', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  label: 'Approve / Verify',
                  icon: Icons.check,
                  onPressed: () => _removeItem(item['id'] as String, 'Approved'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
