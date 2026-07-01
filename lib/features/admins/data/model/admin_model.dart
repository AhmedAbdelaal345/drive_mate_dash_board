enum AdminRole {
  superAdmin,
  serviceCenterAdmin,
  communityAdmin,
  analyticsAdmin,
  contentAdmin;

  String get label => switch (this) {
    AdminRole.superAdmin => 'Super Admin',
    AdminRole.serviceCenterAdmin => 'Ops Admin',
    AdminRole.communityAdmin => 'Community Admin',
    AdminRole.analyticsAdmin => 'Analytics Admin',
    AdminRole.contentAdmin => 'Content Admin',
  };

  static AdminRole fromApi(String value) {
    return AdminRole.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => AdminRole.communityAdmin,
    );
  }
}

class AdminModel {
  const AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final AdminRole role;
  final bool isActive;
  final DateTime createdAt;

  String get status => isActive ? 'Active' : 'Disabled';

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as String? ?? '',
      name: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: AdminRole.fromApi(json['role'] as String? ?? ''),
      isActive: json['isActive'] as bool? ?? true,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
