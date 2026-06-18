
import 'package:drive_mate_dash_board/features/dataset/data/model/dataset_model.dart';

sealed class DatasetsState {
  const DatasetsState();
}

final class DatasetsInitial extends DatasetsState {
  const DatasetsInitial();
}

final class DatasetsLoading extends DatasetsState {
  const DatasetsLoading();
}

final class DatasetsLoaded extends DatasetsState {
  const DatasetsLoaded({
    required this.samples,
    required this.stats,
    required this.query,
    required this.page,
  });

  final List<AudioSample> samples;
  final DatasetsStats stats;
  final String query;
  final int page;
}

final class DatasetsError extends DatasetsState {
  const DatasetsError(this.message);

  final String message;
}

/// Emitted while a single sample action (mark labeled / export) is in flight.
final class DatasetsActionLoading extends DatasetsState {
  const DatasetsActionLoading({
    required this.samples,
    required this.stats,
    required this.query,
    required this.page,
    required this.sampleId,
  });

  final List<AudioSample> samples;
  final DatasetsStats stats;
  final String query;
  final int page;
  final String sampleId;
}

/// Emitted during metadata export (no specific sample targeted).
final class DatasetsExporting extends DatasetsState {
  const DatasetsExporting({
    required this.samples,
    required this.stats,
    required this.query,
    required this.page,
  });

  final List<AudioSample> samples;
  final DatasetsStats stats;
  final String query;
  final int page;
}