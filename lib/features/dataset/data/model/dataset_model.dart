enum SampleLabel { labeled, unlabeled }

class AudioSample {
  const AudioSample({
    required this.id,
    required this.carModel,
    required this.date,
    required this.label,
    this.isProcessed = true,
  });

  final String id;
  final String carModel;
  final String date;
  final SampleLabel label;
  final bool isProcessed;

  AudioSample copyWith({SampleLabel? label, bool? isProcessed}) {
    return AudioSample(
      id: id,
      carModel: carModel,
      date: date,
      label: label ?? this.label,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }

  factory AudioSample.fromJson(Map<String, dynamic> json) {
    return AudioSample(
      id: json['id'] as String,
      carModel: json['car_model'] as String,
      date: json['date'] as String,
      label: (json['label'] as String).toLowerCase() == 'labeled'
          ? SampleLabel.labeled
          : SampleLabel.unlabeled,
      isProcessed: json['is_processed'] as bool? ?? true,
    );
  }
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
}