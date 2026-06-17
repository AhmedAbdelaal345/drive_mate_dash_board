import 'package:drive_mate_dash_board/features/articls/data/model/article_model.dart';

sealed class AnalyticsState {
  const AnalyticsState();
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({
    required this.summary,
    required this.period,
  });

  final AnalyticsSummary summary;
  final AnalyticsPeriod period;
}

final class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);

  final String message;
}