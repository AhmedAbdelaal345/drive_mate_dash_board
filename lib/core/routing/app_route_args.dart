import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';

class AppRouteArgs {
  const AppRouteArgs({required this.adminType, this.payload});

  final AdminType adminType;
  final Object? payload;
}
