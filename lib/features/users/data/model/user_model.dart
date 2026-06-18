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
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinDate: json['join_date'] as String,
      carsCount: json['cars_count'] as int,
      status: UserStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => UserStatus.active,
      ),
      role: (json['role'] as String).toLowerCase() == 'centeradmin'
          ? UserRole.centerAdmin
          : UserRole.user,
    );
  }
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
}