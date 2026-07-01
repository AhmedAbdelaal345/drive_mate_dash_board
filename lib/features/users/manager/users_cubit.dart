import 'package:drive_mate_dash_board/features/users/data/users_repo.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._repo) : super(const UsersInitial());

  final UsersRepo _repo;

  String _query = '';
  int _page = 1;

  // ── Fetch ──────────────────────────────────────────────────────────────────

  Future<void> loadUsers() async {
    emit(const UsersLoading());
    try {
      final results = await Future.wait([
        _repo.fetchUsers(query: _query, page: _page),
        _repo.fetchStats(),
      ]);
      emit(UsersLoaded(
        users: results[0] as dynamic,
        stats: results[1] as dynamic,
        query: _query,
        page: _page,
      ));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  Future<void> search(String query) async {
    _query = query;
    _page = 1;
    await loadUsers();
  }

  // ── Pagination ─────────────────────────────────────────────────────────────

  Future<void> goToPage(int page) async {
    _page = page;
    await loadUsers();
  }

  // ── User actions ───────────────────────────────────────────────────────────

  Future<void> banUser(String userId) => _userAction(
        userId: userId,
        action: () async {
          await _repo.banUser(userId);
          await loadUsers();
        },
      );

  Future<void> unbanUser(String userId) => _userAction(
        userId: userId,
        action: () async {
          await _repo.unbanUser(userId);
          await loadUsers();
        },
      );

  Future<void> deleteUser(String userId) => _userAction(
        userId: userId,
        action: () => _repo.deleteUser(userId),
      );

  Future<void> _userAction({
    required String userId,
    required Future<void> Function() action,
  }) async {
    final current = state;
    if (current is! UsersLoaded) return;

    emit(UsersActionLoading(
      users: current.users,
      stats: current.stats,
      query: current.query,
      page: current.page,
      userId: userId,
    ));

    try {
      await action();
      await loadUsers();
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}