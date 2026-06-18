import 'package:drive_mate_dash_board/features/users/data/model/user_model.dart';

sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  const UsersLoaded({
    required this.users,
    required this.stats,
    required this.query,
    required this.page,
  });

  final List<AppUser> users;
  final UsersStats stats;
  final String query;
  final int page;
}

final class UsersError extends UsersState {
  const UsersError(this.message);

  final String message;
}

/// Emitted while a single user action (ban / unban / delete) is in flight.
final class UsersActionLoading extends UsersState {
  const UsersActionLoading({
    required this.users,
    required this.stats,
    required this.query,
    required this.page,
    required this.userId,
  });

  final List<AppUser> users;
  final UsersStats stats;
  final String query;
  final int page;
  final String userId;
}