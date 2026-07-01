import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';

abstract class UsersRepo {
  Future<List<AppUser>> fetchUsers({String? query, int page});
  Future<UsersStats> fetchStats();
  Future<void> banUser(String userId);
  Future<void> unbanUser(String userId);
  Future<void> deleteUser(String userId);
}

class UsersRepoImpl implements UsersRepo {
  UsersRepoImpl({this.pageSize = 10});

  final int pageSize;

  @override
  Future<List<AppUser>> fetchUsers({String? query, int page = 1}) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/users',
      isAuthorized: true,
      queryParameters: {
        'pageNumber': page,
        'pageSize': pageSize,
        'searchTerm': query?.trim() ?? '',
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((e) => AppUser.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return <AppUser>[];
  }

  @override
  Future<UsersStats> fetchStats() async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/users/stats',
      isAuthorized: true,
    );

    if (response.data is Map) {
      return UsersStats.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    }

    return const UsersStats(total: 0, active: 0, banned: 0);
  }

  @override
  Future<void> banUser(String userId) => _toggleActive(userId);

  @override
  Future<void> unbanUser(String userId) => _toggleActive(userId);

  @override
  Future<void> deleteUser(String userId) async {
    await ApiHelper().deleteRequest(
      endpoint: 'admin/users/$userId',
      isAuthorized: true,
      isForm: false,
    );
  }

  Future<void> _toggleActive(String userId) async {
    try {
      await ApiHelper().putRequest(
        endpoint: 'admin/users/$userId/toggle-active',
        isAuthorized: true,
        isForm: false,
      );
    } on Exception catch (e) {
      if (e.toString() != '404') rethrow;
      await ApiHelper().postRequest(
        endpoint: 'admin/users/$userId/toggle-active',
        isAuthorized: true,
        isForm: false,
      );
    }
  }
}
