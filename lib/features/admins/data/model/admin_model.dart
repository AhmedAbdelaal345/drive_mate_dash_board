import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';

class AdminModel {
  const AdminModel({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  final String name;
  final String email;
  final AdminType role;
  final String status;
}
