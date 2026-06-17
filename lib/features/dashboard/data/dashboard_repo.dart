import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_data_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class DashboardRepo {
  Future<ApiResponse<DashboardDataModel>> getDashboardData() async {
    // TODO: Implement API Integration
    return ApiResponse.success(
      const DashboardDataModel(
        metrics: MockData.dashboardMetrics,
        activities: MockData.activities,
      ),
    );
  }
}
