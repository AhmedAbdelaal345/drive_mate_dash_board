
import 'package:drive_mate_dash_board/features/articls/data/model/article_model.dart';
import 'package:drive_mate_dash_board/features/articls/data/repo/article_repo.dart';
import 'package:drive_mate_dash_board/features/articls/manager/articl_stat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._repo) : super(const AnalyticsInitial());

  final AnalyticsRepo _repo;

  AnalyticsPeriod _currentPeriod = AnalyticsPeriod.sevenDays;
  AnalyticsPeriod get currentPeriod => _currentPeriod;

  /// Loads analytics for the given period and emits [AnalyticsLoaded].
  Future<void> loadSummary([AnalyticsPeriod? period]) async {
    _currentPeriod = period ?? _currentPeriod;
    emit(const AnalyticsLoading());
    try {
      final summary = await _repo.fetchSummary(_currentPeriod);
      emit(AnalyticsLoaded(summary: summary, period: _currentPeriod));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  /// Switches to a new period and re-fetches.
  Future<void> changePeriod(AnalyticsPeriod period) => loadSummary(period);
}