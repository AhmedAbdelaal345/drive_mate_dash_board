class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.joinedDate,
    required this.carsCount,
  });

  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String joinedDate;
  final int carsCount;
}
