enum AdminType { superAdmin, opsAdmin, communityAdmin }

extension AdminTypeX on AdminType {
  String get label {
    switch (this) {
      case AdminType.superAdmin:
        return 'SUPER ADMIN';
      case AdminType.opsAdmin:
        return 'OPS ADMIN';
      case AdminType.communityAdmin:
        return 'COMMUNITY';
    }
  }

  String get readableName {
    switch (this) {
      case AdminType.superAdmin:
        return 'Super Admin';
      case AdminType.opsAdmin:
        return 'Ops Admin';
      case AdminType.communityAdmin:
        return 'Community Admin';
    }
  }

  static AdminType? fromApiRole(String role) {
    final cleanRole = role.trim().toLowerCase();

    return switch (cleanRole) {
      'superadmin' || 'super_admin' || 'super admin' => AdminType.superAdmin,
      'servicecenteradmin' ||
      'service_center_admin' ||
      'operationsadmin' ||
      'operations_admin' ||
      'opsadmin' ||
      'ops_admin' => AdminType.opsAdmin,
      'communityadmin' ||
      'community_admin' ||
      'community admin' => AdminType.communityAdmin,
      _ => null,
    };
  }
}

class AuthModel {
  const AuthModel({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class AuthLoginData {
  final String userId;
  final String fullName;
  final String email;
  final String role;
  final String accessToken;
  final String refreshToken;

  AuthLoginData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthLoginData.fromJson(Map<String, dynamic> json) {
    return AuthLoginData(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}