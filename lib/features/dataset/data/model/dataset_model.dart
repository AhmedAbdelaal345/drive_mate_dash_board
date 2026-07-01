enum SampleLabel { labeled, unlabeled }

class AudioSample {
  const AudioSample({
    required this.id,
    required this.userId,
    required this.deviceHash,
    required this.audioPath,
    required this.result,
    required this.createdAt,
    required this.status,
    required this.isLabeled,
    required this.carModel,
    required this.date,
    required this.label,
    required this.isProcessed,
  });

  final String id;
  final String userId;
  final String deviceHash;
  final String audioPath;
  final String result;
  final String createdAt;
  final String status;
  final bool isLabeled;

  // Compatibility/UI helper fields
  final String carModel;
  final String date;
  final SampleLabel label;
  final bool isProcessed;

  factory AudioSample.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] as String? ?? '';
    final rawUserId = json['userId'] as String? ?? '';
    final rawDeviceHash = json['deviceHash'] as String? ?? '';
    final rawAudioPath = json['audioPath'] as String? ?? '';
    final rawResult = json['result'] as String? ?? '';
    final rawCreatedAt = json['createdAt'] as String? ?? '';
    final rawStatus = json['status'] as String? ?? '';
    final rawIsLabeled = json['isLabeled'] as bool? ?? false;

    // Build user-friendly label/carModel fallbacks
    final displayCarModel = json['carModel'] as String? ??
        json['car_model'] as String? ??
        (rawDeviceHash.isNotEmpty
            ? 'Device: ${rawDeviceHash.substring(0, rawDeviceHash.length.clamp(0, 6))}'
            : 'Unknown Device');

    return AudioSample(
      id: rawId,
      userId: rawUserId,
      deviceHash: rawDeviceHash,
      audioPath: rawAudioPath,
      result: rawResult,
      createdAt: rawCreatedAt,
      status: rawStatus,
      isLabeled: rawIsLabeled,
      carModel: displayCarModel,
      date: _formatDate(rawCreatedAt),
      label: rawIsLabeled ? SampleLabel.labeled : SampleLabel.unlabeled,
      isProcessed: rawStatus.toLowerCase() == 'processed',
    );
  }

  static String _formatDate(String value) {
    if (value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.year}-${_twoDigits(parsed.month)}-${_twoDigits(parsed.day)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class DatasetsStats {
  const DatasetsStats({
    required this.total,
    required this.processed,
    required this.labeled,
  });

  final int total;
  final int processed;
  final int labeled;

  factory DatasetsStats.fromJson(Map<String, dynamic> json) {
    return DatasetsStats(
      total: json['total'] as int? ?? json['totalUsers'] as int? ?? 0,
      processed: json['processed'] as int? ?? json['activeUsers'] as int? ?? 0,
      labeled: json['labeled'] as int? ?? json['bannedUsers'] as int? ?? 0,
    );
  }
}

class CatalogImportItem {
  const CatalogImportItem({
    required this.brand,
    required this.model,
    required this.specs,
    required this.tags,
  });

  final String brand;
  final String model;
  final Map<String, String> specs;
  final List<String> tags;

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'specs': specs,
      'tags': tags,
    };
  }
}
