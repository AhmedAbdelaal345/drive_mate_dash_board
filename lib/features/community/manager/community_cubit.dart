import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';
import 'package:drive_mate_dash_board/features/community/data/repo/community_repo.dart';
import 'package:drive_mate_dash_board/features/community/manager/community_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._repo) : super(const CommunityInitial());

  final CommunityRepo _repo;

  CommunityFilter _filter = CommunityFilter.all;
  String _query = '';

  Future<void> loadPosts() async {
    emit(const CommunityLoading());
    try {
      final response = await _repo.fetchPosts(
        searchTerm: _query,
        filter: _filter,
      );
      emit(
        response.fold(
          (l) => CommunityError(l),
          (r) => CommunityLoaded(posts: r, filter: _filter, query: _query),
        ),
      );
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> changeFilter(CommunityFilter filter) async {
    _filter = filter;
    await loadPosts();
  }

  Future<void> search(String query) async {
    _query = query;
    await loadPosts();
  }

  Future<void> approvePost(String postId) =>
      _runAction(postId: postId, action: () => _repo.approvePost(postId));

  Future<void> deletePost(String postId) =>
      _runAction(postId: postId, action: () => _repo.deletePost(postId));

  Future<void> _runAction({
    required String postId,
    required Future<void> Function() action,
  }) async {
    final current = state;
    if (current is! CommunityLoaded) return;

    emit(
      CommunityActionLoading(
        posts: current.posts,
        filter: current.filter,
        query: current.query,
        postId: postId,
      ),
    );

    try {
      await action();
      await loadPosts();
    } on Exception catch (e) {
      emit(CommunityError(e.toString()));
    }
  }
}
