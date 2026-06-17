import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/admins/data/model/admin_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class AdminsRepo {
  Future<ApiResponse<List<AdminModel>>> getAdmins() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.admins);
  }
}
