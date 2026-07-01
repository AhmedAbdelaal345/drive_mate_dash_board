import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/articls/data/model/article_model.dart';

abstract class AnalyticsRepo {
  Future<AnalyticsSummary> fetchSummary(AnalyticsPeriod period);
}

class AnalyticsRepoImpl implements AnalyticsRepo {
  @override
  Future<AnalyticsSummary> fetchSummary(AnalyticsPeriod period) async {
    final periodValue = period.apiValue;

    final results = await Future.wait([
      _fetchTopCars(periodValue),
      _fetchTopParts(periodValue),
      _fetchTopServiceCenters(periodValue),
      _fetchAudioStats(periodValue),
    ]);

    return AnalyticsSummary.fromParts(
      topCars: results[0] as List<TopCarEntry>,
      topParts: results[1] as List<PartEntry>,
      topServiceCenters: results[2] as List<ServiceCenterEntry>,
      audioDataset: results[3] as AudioDataset,
    );
  }

  Future<List<TopCarEntry>> _fetchTopCars(String period) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/analytics/top-cars',
      isAuthorized: true,
      queryParameters: {'period': period},
    );

    return response.data ?? <TopCarEntry>[];
  }

  Future<List<PartEntry>> _fetchTopParts(String period) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/analytics/top-parts',
      isAuthorized: true,
      queryParameters: {'period': period},
    );

    return response.data ?? <PartEntry>[];
  }

  Future<List<ServiceCenterEntry>> _fetchTopServiceCenters(String period) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/analytics/top-service-centers',
      isAuthorized: true,
      queryParameters: {'period': period},
    );

    return response.data ?? <ServiceCenterEntry>[];
  }

  Future<AudioDataset> _fetchAudioStats(String period) async {
    final response = await ApiHelper().getRequest(
      endpoint: 'admin/analytics/audio-stats',
      isAuthorized: true,
      queryParameters: {'period': period},
    );

    return response.data ?? const AudioDataset(total: 0, processed: 0, labeled: 0);
  }

  List<T> _parseItems<T>(
    Object? data,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (data is! Map) return <T>[];
    final items = data['items'];
    if (items is! List) return <T>[];

    return items
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
