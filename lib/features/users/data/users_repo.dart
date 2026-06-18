import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';

abstract class UsersRepo {
  Future<List<AppUser>> fetchUsers({String? query, int page});
  Future<UsersStats> fetchStats();
  Future<void> banUser(String userId);
  Future<void> unbanUser(String userId);
  Future<void> deleteUser(String userId);
}

class UsersRepoImpl implements UsersRepo {
  // final Dio _dio;
  // UsersRepoImpl(this._dio);

  @override
  Future<List<AppUser>> fetchUsers({String? query, int page = 1}) async {
    // TODO: replace with real API call:
    // final res = await _dio.get('/users', queryParameters: {
    //   'page': page,
    //   if (query != null && query.isNotEmpty) 'q': query,
    // });
    // return (res.data['users'] as List)
    //     .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));

    var users = _mockUsers;

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      users = users
          .where(
            (u) =>
                u.name.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q),
          )
          .toList();
    }

    return users;
  }

  @override
  Future<UsersStats> fetchStats() async {
    // TODO: await _dio.get('/users/stats')
    await Future.delayed(const Duration(milliseconds: 300));
    return const UsersStats(total: 50, active: 41, banned: 5);
  }

  @override
  Future<void> banUser(String userId) async {
    // TODO: await _dio.patch('/users/$userId/ban');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> unbanUser(String userId) async {
    // TODO: await _dio.patch('/users/$userId/unban');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteUser(String userId) async {
    // TODO: await _dio.delete('/users/$userId');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // ── Mock data ──────────────────────────────────────────────────────────────

  static const List<AppUser> _mockUsers = [
    AppUser(
      id: 'u1',
      name: 'Ali Fahad',
      email: 'ali.fahad24@example.com',
      joinDate: '6/16/2026',
      carsCount: 0,
      status: UserStatus.active,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u2',
      name: 'Khalid Al-Sayed',
      email: 'khalid.al-sayed36@example.com',
      joinDate: '6/14/2026',
      carsCount: 1,
      status: UserStatus.active,
      role: UserRole.centerAdmin,
    ),
    AppUser(
      id: 'u3',
      name: 'Sara Mahmoud',
      email: 'sara.mahmoud14@example.com',
      joinDate: '6/13/2026',
      carsCount: 0,
      status: UserStatus.active,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u4',
      name: 'Ali Al-Sayed',
      email: 'ali.al-sayed4@example.com',
      joinDate: '6/12/2026',
      carsCount: 1,
      status: UserStatus.active,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u5',
      name: 'Mohamed Abdullah',
      email: 'mohamed.a@example.com',
      joinDate: '6/10/2026',
      carsCount: 2,
      status: UserStatus.suspended,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u6',
      name: 'Fatima Al Zahra',
      email: 'fatima.z@example.com',
      joinDate: '6/8/2026',
      carsCount: 3,
      status: UserStatus.active,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u7',
      name: 'Hassan Nour',
      email: 'hassan.n@example.com',
      joinDate: '6/5/2026',
      carsCount: 0,
      status: UserStatus.banned,
      role: UserRole.user,
    ),
    AppUser(
      id: 'u8',
      name: 'Rania Ibrahim',
      email: 'rania.i@example.com',
      joinDate: '6/3/2026',
      carsCount: 1,
      status: UserStatus.active,
      role: UserRole.centerAdmin,
    ),
  ];
}