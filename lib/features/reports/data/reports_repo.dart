import 'package:dartz/dartz.dart';
import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/reports/data/model/report_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class ReportsRepo {
  ReportsRepo._singleTone();
  static final ReportsRepo _instance = ReportsRepo._singleTone();

  factory ReportsRepo() {
    return _instance;
  }

  Future<Either<String, List<ReportModel>>> getReports() async {
    try {
      ApiResponse response = await ApiHelper().getRequest(
        endpoint: "admin/reports",
        queryParameters: {"pageNumber": 1, "pageSize": 10, "searchTerm": ""},
      );
      if (response.statusCode == 200) {
        List<ReportModel> reports = response.data
            .map<ReportModel>((x) => ReportModel.fromJson(x))
            .toList();
        reports.addAll(MockData.reports);
        return Right(reports);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
