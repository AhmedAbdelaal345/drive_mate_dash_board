import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';
import 'package:drive_mate_dash_board/features/community/data/repo/community_repo.dart';
import 'package:drive_mate_dash_board/features/community/manager/community_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._repo) : super(const CommunityInitial());

  final CommunityRepo _repo;

  CommunityFilter _filter = CommunityFilter.all;
  String _query = '';

  CommunityFilter get currentFilter => _filter;
  String get currentQuery => _query;

  // ── Fetch ──────────────────────────────────────────────────────────────────

  Future<void> loadPosts() async {
    emit(const CommunityLoading());
    try {
      final posts = await _repo.fetchPosts(filter: _filter, query: _query);
      emit(CommunityLoaded(posts: posts, filter: _filter, query: _query));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  // ── Filter & search ────────────────────────────────────────────────────────

  Future<void> changeFilter(CommunityFilter filter) async {
    _filter = filter;
    await loadPosts();
  }

  Future<void> search(String query) async {
    _query = query;
    await loadPosts();
  }

  // ── Post actions ───────────────────────────────────────────────────────────

  Future<void> flagPost(String postId) => _postAction(
        postId: postId,
        action: () => _repo.flagPost(postId),
      );

  Future<void> approvePost(String postId) => _postAction(
        postId: postId,
        action: () => _repo.approvePost(postId),
      );

  Future<void> deletePost(String postId) => _postAction(
        postId: postId,
        action: () => _repo.deletePost(postId),
      );

  Future<void> _postAction({
    required String postId,
    required Future<void> Function() action,
  }) async {
    final current = state;
    if (current is! CommunityLoaded) return;

    emit(CommunityActionLoading(
      posts: current.posts,
      filter: current.filter,
      query: current.query,
      postId: postId,
    ));

    try {
      await action();
      await loadPosts(); // refresh list from server
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }
}