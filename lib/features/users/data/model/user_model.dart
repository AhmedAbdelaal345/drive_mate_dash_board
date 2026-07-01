enum UserStatus { active, suspended, banned }

enum UserRole { user, centerAdmin }

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.user => 'User',
        UserRole.centerAdmin => 'Center Admin',
      };
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
    required this.carsCount,
    required this.status,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String joinDate;
  final int carsCount;
  final UserStatus status;
  final UserRole role;

  AppUser copyWith({UserStatus? status, UserRole? role}) {
    return AppUser(
      id: id,
      name: name,
      email: email,
      joinDate: joinDate,
      carsCount: carsCount,
      status: status ?? this.status,
      role: role ?? this.role,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final apiRole = (json['role'] as String? ?? '').toLowerCase();
    final isActive = json['isActive'] as bool?;
    final rawCreatedAt = json['createdAt'] as String? ?? '';

    return AppUser(
      id: json['id'] as String? ?? '',
      name: json['fullName'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      joinDate: _formatDate(rawCreatedAt),
      carsCount: json['carsCount'] as int? ?? json['cars_count'] as int? ?? 0,
      status: isActive == false ? UserStatus.banned : UserStatus.active,
      role: apiRole.contains('servicecenter') || apiRole.contains('centeradmin')
          ? UserRole.centerAdmin
          : UserRole.user,
    );
  }

  static String _formatDate(String value) {
    if (value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.year}-${_twoDigits(parsed.month)}-${_twoDigits(parsed.day)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class UsersStats {
  const UsersStats({
    required this.total,
    required this.active,
    required this.banned,
  });

  final int total;
  final int active;
  final int banned;

  factory UsersStats.fromJson(Map<String, dynamic> json) {
    return UsersStats(
      total: json['totalUsers'] as int? ?? json['total'] as int? ?? 0,
      active: json['activeUsers'] as int? ?? json['active'] as int? ?? 0,
      banned: json['bannedUsers'] as int? ?? json['banned'] as int? ?? 0,
    );
  }
}
