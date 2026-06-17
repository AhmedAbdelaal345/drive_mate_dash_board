import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/service_centers/data/model/service_center_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class ServiceCentersRepo {
  Future<ApiResponse<List<ServiceCenterModel>>> getCenters() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.centers);
  }
}
