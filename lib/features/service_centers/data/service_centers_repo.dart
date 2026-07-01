import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/service_centers/data/model/service_center_model.dart';

class ServiceCentersRepo {
  ServiceCentersRepo._singleTone();
  static final ServiceCentersRepo instance = ServiceCentersRepo._singleTone();
  factory ServiceCentersRepo() => instance;

  Future<List<ServiceCenterModel>> getCenters({
    int pageNumber = 1,
    int pageSize = 10,
    String searchTerm = '',
  }) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/service-centers',
      isAuthorized: true,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'searchTerm': searchTerm,
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((e) => ServiceCenterModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <ServiceCenterModel>[];
  }

  Future<ApiResponse> createCenter({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
  }) async {
    return await ApiHelper().postRequest(
      endpoint: 'admin/service-centers',
      isAuthorized: true,
      isForm: false,
      data: {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
      },
    );
  }
}
