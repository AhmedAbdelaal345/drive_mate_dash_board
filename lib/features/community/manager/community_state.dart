import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';

sealed class CommunityState {
  const CommunityState();
}

final class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

final class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

final class CommunityLoaded extends CommunityState {
  const CommunityLoaded({
    required this.posts,
    required this.filter,
    required this.query,
  });

  final List<CommunityPost> posts;
  final CommunityFilter filter;
  final String query;
}

final class CommunityError extends CommunityState {
  const CommunityError(this.message);

  final String message;
}

/// Emitted while a single post action (flag / approve / delete) is in flight.
final class CommunityActionLoading extends CommunityState {
  const CommunityActionLoading({
    required this.posts,
    required this.filter,
    required this.query,
    required this.postId,
  });

  final List<CommunityPost> posts;
  final CommunityFilter filter;
  final String query;
  final String postId;
}