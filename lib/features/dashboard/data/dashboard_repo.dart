import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_data_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_metric_model.dart';

class DashboardRepo {
  Future<DashboardDataModel> getDashboardData() async {
    final results = await Future.wait([
      getDashboardStats(),
      getDashboardLogs(),
    ]);

    return DashboardDataModel(
      metrics: (results[0] as DashboardStatsModel).toMetrics(),
      activities: results[1] as List<ActivityItemModel>,
    );
  }

  Future<DashboardStatsModel> getDashboardStats() async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/dashboard/stats',
      isAuthorized: true,
    );

    if (response.data is Map) {
      return DashboardStatsModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    }

    return const DashboardStatsModel(
      activeUsers: 0,
      totalCars: 0,
      revenue: 0,
      pendingReviews: 0,
    );
  }

  Future<List<ActivityItemModel>> getDashboardLogs() async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/dashboard/logs',
      isAuthorized: true,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((e) => ActivityItemModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    }

    return <ActivityItemModel>[];
  }
}
