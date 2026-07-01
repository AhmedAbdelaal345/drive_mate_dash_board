import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';

class CarsRepo {
  Future<ApiResponse> getCars({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  }) async {
    try {
      return ApiHelper().getRequest(
        endpoint: 'admin/cars',
        isAuthorized: true,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'searchTerm': searchTerm,
        },
      );
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> createCar(CreateCarRequest request) async {
    try {
      return ApiHelper().postRequest(
        endpoint: 'admin/cars',
        isAuthorized: true,
        isForm: false,
        data: request.toJson(),
      );
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> updateCar({
    required int id,
    required UpdateCarRequest request,
  }) async {
    try {
      return ApiHelper().putRequest(
        endpoint: 'admin/cars/$id',
        isAuthorized: true,
        isForm: false,
        data: request.toJson(),
      );
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}
