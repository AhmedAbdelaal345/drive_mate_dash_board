import 'package:drive_mate_dash_board/features/articls/data/model/article_model.dart';

abstract class AnalyticsRepo {
  Future<AnalyticsSummary> fetchSummary(AnalyticsPeriod period);
}

class AnalyticsRepoImpl implements AnalyticsRepo {
  // Replace with your real Dio/http client and base-url.
  // final Dio _dio;
  // AnalyticsRepoImpl(this._dio);

  @override
  Future<AnalyticsSummary> fetchSummary(AnalyticsPeriod period) async {
    // TODO: replace with real API call:
    // final res = await _dio.get('/analytics', queryParameters: {'period': period.apiValue});
    // return AnalyticsSummary.fromJson(res.data as Map<String, dynamic>);

    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    return _mockData[period]!;
  }

  // ── Mock data (delete once API is wired) ───────────────────────────────────

  static final Map<AnalyticsPeriod, AnalyticsSummary> _mockData = {
    AnalyticsPeriod.today: _build(
      topCar: 'Toyota Camry 2024',
      topCarCount: '12 added',
      topPart: 'Brake Pads',
      topPartCount: '45 replaced',
      topCenter: 'Dubai Main Workshop',
      topCenterCount: '30 visits',
      audioSamples: '620',
      topCars: [
        TopCarEntry(name: 'Toyota Camry 2024', count: 12),
        TopCarEntry(name: 'Nissan Patrol', count: 8),
        TopCarEntry(name: 'Tesla Model 3', count: 6),
        TopCarEntry(name: 'Hyundai Tucson', count: 5),
        TopCarEntry(name: 'Ford Mustang', count: 3),
      ],
      audioTotal: 620,
      audioProcessed: 425,
      audioLabeled: 210,
    ),
    AnalyticsPeriod.sevenDays: _build(
      topCar: 'Toyota Camry 2024',
      topCarCount: '84 added',
      topPart: 'Brake Pads',
      topPartCount: '315 replaced',
      topCenter: 'Dubai Main Workshop',
      topCenterCount: '203 visits',
      audioSamples: '4,340',
      topCars: [
        TopCarEntry(name: 'Toyota Camry 2024', count: 84),
        TopCarEntry(name: 'Nissan Patrol', count: 56),
        TopCarEntry(name: 'Tesla Model 3', count: 42),
        TopCarEntry(name: 'Hyundai Tucson', count: 35),
        TopCarEntry(name: 'Ford Mustang', count: 21),
      ],
      audioTotal: 4340,
      audioProcessed: 2975,
      audioLabeled: 1470,
    ),
    AnalyticsPeriod.thirtyDays: _build(
      topCar: 'Toyota Camry 2024',
      topCarCount: '310 added',
      topPart: 'Oil Filter',
      topPartCount: '890 replaced',
      topCenter: 'Abu Dhabi Service Point',
      topCenterCount: '540 visits',
      audioSamples: '16,200',
      topCars: [
        TopCarEntry(name: 'Toyota Camry 2024', count: 310),
        TopCarEntry(name: 'Nissan Patrol', count: 210),
        TopCarEntry(name: 'Tesla Model 3', count: 175),
        TopCarEntry(name: 'Hyundai Tucson', count: 130),
        TopCarEntry(name: 'Ford Mustang', count: 88),
      ],
      audioTotal: 16200,
      audioProcessed: 11100,
      audioLabeled: 5480,
    ),
    AnalyticsPeriod.ninetyDays: _build(
      topCar: 'Nissan Patrol',
      topCarCount: '920 added',
      topPart: 'Air Filter',
      topPartCount: '2,400 replaced',
      topCenter: 'Sharjah Quick Fix',
      topCenterCount: '1,620 visits',
      audioSamples: '48,900',
      topCars: [
        TopCarEntry(name: 'Nissan Patrol', count: 920),
        TopCarEntry(name: 'Toyota Camry 2024', count: 870),
        TopCarEntry(name: 'Tesla Model 3', count: 510),
        TopCarEntry(name: 'Hyundai Tucson', count: 390),
        TopCarEntry(name: 'Ford Mustang', count: 260),
      ],
      audioTotal: 48900,
      audioProcessed: 33500,
      audioLabeled: 16540,
    ),
  };

  static AnalyticsSummary _build({
    required String topCar,
    required String topCarCount,
    required String topPart,
    required String topPartCount,
    required String topCenter,
    required String topCenterCount,
    required String audioSamples,
    required List<TopCarEntry> topCars,
    required int audioTotal,
    required int audioProcessed,
    required int audioLabeled,
  }) {
    return AnalyticsSummary(
      topCar: topCar,
      topCarCount: topCarCount,
      topPart: topPart,
      topPartCount: topPartCount,
      topCenter: topCenter,
      topCenterCount: topCenterCount,
      audioSamples: audioSamples,
      topCars: topCars,
      mostChangedParts: const [
        PartEntry(name: 'Brake Pads', count: 315),
        PartEntry(name: 'Oil Filter', count: 266),
        PartEntry(name: 'Air Filter', count: 224),
        PartEntry(name: 'Spark Plugs', count: 147),
        PartEntry(name: 'Battery', count: 126),
      ],
      topServiceCenters: const [
        ServiceCenterEntry(
          name: 'Dubai Main Workshop',
          visits: 203,
          bookings: 168,
          emergency: 35,
        ),
        ServiceCenterEntry(
          name: 'Abu Dhabi Service Point',
          visits: 140,
          bookings: 126,
          emergency: 14,
        ),
        ServiceCenterEntry(
          name: 'Sharjah Quick Fix',
          visits: 140,
          bookings: 84,
          emergency: 56,
        ),
      ],
      audioDataset: AudioDataset(
        total: audioTotal,
        processed: audioProcessed,
        labeled: audioLabeled,
      ),
    );
  }
}