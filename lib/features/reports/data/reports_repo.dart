import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/reports/data/model/report_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class ReportsRepo {
  Future<ApiResponse<List<ReportModel>>> getReports() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.reports);
  }
}
