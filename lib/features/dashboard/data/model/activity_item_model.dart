class ActivityItemModel {
  const ActivityItemModel({
    required this.title,
    required this.subtitle,
    required this.actor,
    required this.time,
    required this.type,
  });

  final String title;
  final String subtitle;
  final String actor;
  final String time;
  final String type;

  factory ActivityItemModel.fromJson(Map<String, dynamic> json) {
    final action = json['action'] as String? ?? '';
    final timestamp = json['timestamp'] as String? ?? '';

    return ActivityItemModel(
      title: action,
      subtitle: _subtitleFromAction(action),
      actor: json['actor'] as String? ?? 'System',
      time: _formatTimestamp(timestamp),
      type: _typeFromAction(action),
    );
  }

  static String _subtitleFromAction(String action) {
    if (action.trim().isEmpty) return 'System activity';
    return action;
  }

  static String _typeFromAction(String action) {
    final cleanAction = action.toLowerCase();
    if (cleanAction.contains('car') || cleanAction.contains('catalog')) {
      return 'Cars';
    }
    if (cleanAction.contains('post') || cleanAction.contains('review')) {
      return 'Community';
    }
    if (cleanAction.contains('service center')) return 'Centers';
    if (cleanAction.contains('audio') || cleanAction.contains('sample')) {
      return 'Datasets';
    }
    if (cleanAction.contains('user')) return 'Users';
    return 'System';
  }

  static String _formatTimestamp(String value) {
    final timestamp = DateTime.tryParse(value)?.toLocal();
    if (timestamp == null) return value;

    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays}d ago';
  }
}
