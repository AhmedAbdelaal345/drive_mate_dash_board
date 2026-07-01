class AnalyticsSummary {
  const AnalyticsSummary({
    required this.topCar,
    required this.topCarCount,
    required this.topPart,
    required this.topPartCount,
    required this.topCenter,
    required this.topCenterCount,
    required this.audioSamples,
    required this.topCars,
    required this.mostChangedParts,
    required this.topServiceCenters,
    required this.audioDataset,
  });

  final String topCar;
  final String topCarCount;
  final String topPart;
  final String topPartCount;
  final String topCenter;
  final String topCenterCount;
  final String audioSamples;
  final List<TopCarEntry> topCars;
  final List<PartEntry> mostChangedParts;
  final List<ServiceCenterEntry> topServiceCenters;
  final AudioDataset audioDataset;

  factory AnalyticsSummary.fromParts({
    required List<TopCarEntry> topCars,
    required List<PartEntry> topParts,
    required List<ServiceCenterEntry> topServiceCenters,
    required AudioDataset audioDataset,
  }) {
    final topCar = topCars.isEmpty ? null : topCars.first;
    final topPart = topParts.isEmpty ? null : topParts.first;
    final topCenter = topServiceCenters.isEmpty ? null : topServiceCenters.first;

    return AnalyticsSummary(
      topCar: topCar?.name ?? 'No data',
      topCarCount: topCar == null ? '0 added' : '${topCar.count} added',
      topPart: topPart?.name ?? 'No data',
      topPartCount: topPart == null ? '0 changed' : '${topPart.count} changed',
      topCenter: topCenter?.name ?? 'No data',
      topCenterCount: topCenter == null ? '0 visits' : '${topCenter.visits} visits',
      audioSamples: '${audioDataset.total}',
      topCars: topCars,
      mostChangedParts: topParts,
      topServiceCenters: topServiceCenters,
      audioDataset: audioDataset,
    );
  }

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      topCar: json['top_car'] as String? ?? 'No data',
      topCarCount: json['top_car_count'] as String? ?? '0 added',
      topPart: json['top_part'] as String? ?? 'No data',
      topPartCount: json['top_part_count'] as String? ?? '0 changed',
      topCenter: json['top_center'] as String? ?? 'No data',
      topCenterCount: json['top_center_count'] as String? ?? '0 visits',
      audioSamples: json['audio_samples'] as String? ?? '0',
      topCars: ((json['top_cars'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => TopCarEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      mostChangedParts: ((json['most_changed_parts'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => PartEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      topServiceCenters: ((json['top_service_centers'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => ServiceCenterEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      audioDataset: AudioDataset.fromJson(
        json['audio_dataset'] is Map
            ? Map<String, dynamic>.from(json['audio_dataset'] as Map)
            : const {},
      ),
    );
  }
}

class TopCarEntry {
  const TopCarEntry({required this.name, required this.count});

  final String name;
  final int count;

  factory TopCarEntry.fromJson(Map<String, dynamic> json) {
    final brand = json['brand'] as String?;
    final model = json['model'] as String?;
    final fallbackName = json['name'] as String? ??
        json['carName'] as String? ??
        json['title'] as String? ??
        'Unknown car';

    return TopCarEntry(
      name: [brand, model].whereType<String>().where((v) => v.isNotEmpty).join(' ').trim().isEmpty
          ? fallbackName
          : [brand, model].whereType<String>().where((v) => v.isNotEmpty).join(' '),
      count: _readInt(json, const ['count', 'total', 'usageCount', 'views']),
    );
  }
}

class PartEntry {
  const PartEntry({required this.name, required this.count});

  final String name;
  final int count;

  factory PartEntry.fromJson(Map<String, dynamic> json) {
    return PartEntry(
      name: json['name'] as String? ??
          json['partName'] as String? ??
          json['part'] as String? ??
          'Unknown part',
      count: _readInt(json, const ['count', 'total', 'changeCount', 'usageCount']),
    );
  }
}

class ServiceCenterEntry {
  const ServiceCenterEntry({
    required this.name,
    required this.visits,
    required this.bookings,
    required this.emergency,
  });

  final String name;
  final int visits;
  final int bookings;
  final int emergency;

  factory ServiceCenterEntry.fromJson(Map<String, dynamic> json) {
    final visits = _readInt(json, const ['visits', 'count', 'total']);

    return ServiceCenterEntry(
      name: json['name'] as String? ??
          json['serviceCenterName'] as String? ??
          json['centerName'] as String? ??
          'Unknown center',
      visits: visits,
      bookings: _readInt(json, const ['bookings', 'bookingCount'], fallback: visits),
      emergency: _readInt(json, const ['emergency', 'emergencyCount']),
    );
  }
}

class AudioDataset {
  const AudioDataset({
    required this.total,
    required this.processed,
    required this.labeled,
  });

  final int total;
  final int processed;
  final int labeled;

  double get processingProgress => total == 0 ? 0 : processed / total;

  factory AudioDataset.fromJson(Map<String, dynamic> json) {
    final total = _readInt(json, const ['totalScans', 'total', 'samples']);
    final dailyStats = json['dailyStats'];
    final processed = dailyStats is List
        ? dailyStats
            .whereType<Map>()
            .fold<int>(0, (sum, item) => sum + _readInt(Map<String, dynamic>.from(item), const ['count']))
        : _readInt(json, const ['processed'], fallback: total);

    return AudioDataset(
      total: total,
      processed: processed,
      labeled: _readInt(json, const ['labeled', 'labeledSamples']),
    );
  }
}

/// Supported time-range periods for analytics.
enum AnalyticsPeriod { today, sevenDays, thirtyDays, ninetyDays }

extension AnalyticsPeriodLabel on AnalyticsPeriod {
  String get label => switch (this) {
        AnalyticsPeriod.today => 'Today',
        AnalyticsPeriod.sevenDays => '7D',
        AnalyticsPeriod.thirtyDays => '30D',
        AnalyticsPeriod.ninetyDays => '90D',
      };

  String get apiValue => switch (this) {
        AnalyticsPeriod.today => 'today',
        AnalyticsPeriod.sevenDays => '7d',
        AnalyticsPeriod.thirtyDays => '30d',
        AnalyticsPeriod.ninetyDays => '90d',
      };
}

int _readInt(
  Map<String, dynamic> json,
  List<String> keys, {
  int fallback = 0,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
  }
  return fallback;
}
