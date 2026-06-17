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
}

class AuthModel {
  const AuthModel({required this.email, required this.password});

  final String email;
  final String password;
}
