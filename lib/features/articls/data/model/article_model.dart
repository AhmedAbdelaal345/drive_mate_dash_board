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

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      topCar: json['top_car'] as String,
      topCarCount: json['top_car_count'] as String,
      topPart: json['top_part'] as String,
      topPartCount: json['top_part_count'] as String,
      topCenter: json['top_center'] as String,
      topCenterCount: json['top_center_count'] as String,
      audioSamples: json['audio_samples'] as String,
      topCars: (json['top_cars'] as List)
          .map((e) => TopCarEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostChangedParts: (json['most_changed_parts'] as List)
          .map((e) => PartEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      topServiceCenters: (json['top_service_centers'] as List)
          .map((e) => ServiceCenterEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioDataset: AudioDataset.fromJson(
        json['audio_dataset'] as Map<String, dynamic>,
      ),
    );
  }
}

class TopCarEntry {
  const TopCarEntry({required this.name, required this.count});

  final String name;
  final int count;

  factory TopCarEntry.fromJson(Map<String, dynamic> json) {
    return TopCarEntry(
      name: json['name'] as String,
      count: json['count'] as int,
    );
  }
}

class PartEntry {
  const PartEntry({required this.name, required this.count});

  final String name;
  final int count;

  factory PartEntry.fromJson(Map<String, dynamic> json) {
    return PartEntry(
      name: json['name'] as String,
      count: json['count'] as int,
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
    return ServiceCenterEntry(
      name: json['name'] as String,
      visits: json['visits'] as int,
      bookings: json['bookings'] as int,
      emergency: json['emergency'] as int,
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

  double get processingProgress =>
      total == 0 ? 0 : processed / total;

  factory AudioDataset.fromJson(Map<String, dynamic> json) {
    return AudioDataset(
      total: json['total'] as int,
      processed: json['processed'] as int,
      labeled: json['labeled'] as int,
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