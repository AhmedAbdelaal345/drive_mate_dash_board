import 'package:drive_mate_dash_board/features/dataset/data/repo/dataset_repo.dart';
import 'package:drive_mate_dash_board/features/dataset/manager/dataset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatasetsCubit extends Cubit<DatasetsState> {
  DatasetsCubit(this._repo) : super(const DatasetsInitial());

  final DatasetsRepo _repo;

  String _query = '';
  int _page = 1;

  // ── Fetch ──────────────────────────────────────────────────────────────────

  Future<void> loadSamples() async {
    emit(const DatasetsLoading());
    try {
      final results = await Future.wait([
        _repo.fetchSamples(query: _query, page: _page),
        _repo.fetchStats(),
      ]);
      emit(DatasetsLoaded(
        samples: results[0] as dynamic,
        stats: results[1] as dynamic,
        query: _query,
        page: _page,
      ));
    } catch (e) {
      emit(DatasetsError(e.toString()));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  Future<void> search(String query) async {
    _query = query;
    _page = 1;
    await loadSamples();
  }

  // ── Pagination ─────────────────────────────────────────────────────────────

  Future<void> goToPage(int page) async {
    _page = page;
    await loadSamples();
  }

  // ── Sample actions ─────────────────────────────────────────────────────────

  Future<void> markAsLabeled(String sampleId) async {
    final current = state;
    if (current is! DatasetsLoaded) return;

    emit(DatasetsActionLoading(
      samples: current.samples,
      stats: current.stats,
      query: current.query,
      page: current.page,
      sampleId: sampleId,
    ));

    try {
      await _repo.markAsLabeled(sampleId);
      await loadSamples();
    } catch (e) {
      emit(DatasetsError(e.toString()));
    }
  }

  Future<void> exportMetadata() async {
    final current = state;
    if (current is! DatasetsLoaded) return;

    emit(DatasetsExporting(
      samples: current.samples,
      stats: current.stats,
      query: current.query,
      page: current.page,
    ));

    try {
      await _repo.exportMetadata();
      // Restore loaded state after export completes
      emit(DatasetsLoaded(
        samples: current.samples,
        stats: current.stats,
        query: current.query,
        page: current.page,
      ));
    } catch (e) {
      emit(DatasetsError(e.toString()));
    }
  }
}