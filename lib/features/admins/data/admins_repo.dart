import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/admins/data/model/admin_model.dart';

abstract class AdminsRepo {
  Future<Either<String, List<AdminModel>>> fetchAdmins({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  });
}

class AdminsRepoImpl implements AdminsRepo {
  AdminsRepoImpl({ApiHelper? apiHelper}) : _api = apiHelper ?? ApiHelper();

  final ApiHelper _api;

  static const String _endpoint = 'admin/system-admins';

  @override
  Future<Either<String, List<AdminModel>>> fetchAdmins({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  }) async {
    try {
      final res = await _api.getRequest(
        endpoint: _endpoint,
        isAuthorized: true,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'searchTerm': searchTerm,
        },
      );
      final admins = (res.data as List)
          .map((e) => AdminModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      if (res.statusCode == 200) {
        return Right(admins);
      } else {
        return Left(res.message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
