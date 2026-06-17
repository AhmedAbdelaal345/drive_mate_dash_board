import 'package:drive_mate_dash_board/core/routing/app_router.dart';
import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_theme.dart';
import 'package:drive_mate_dash_board/features/admins/data/admins_repo.dart';
import 'package:drive_mate_dash_board/features/admins/manager/admins_cubit.dart';
import 'package:drive_mate_dash_board/features/auth/manager/auth_cubit.dart';
import 'package:drive_mate_dash_board/features/cars/data/cars_repo.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_cubit.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/dashboard_repo.dart';
import 'package:drive_mate_dash_board/features/dashboard/manager/dashboard_cubit.dart';
import 'package:drive_mate_dash_board/features/reports/data/reports_repo.dart';
import 'package:drive_mate_dash_board/features/reports/manager/reports_cubit.dart';
import 'package:drive_mate_dash_board/features/service_centers/data/service_centers_repo.dart';
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_cubit.dart';
import 'package:drive_mate_dash_board/features/tips/data/tips_repo.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_cubit.dart';
import 'package:drive_mate_dash_board/features/users/data/users_repo.dart';
import 'package:drive_mate_dash_board/features/users/manager/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const DriverMateDashboardApp());
}

class DriverMateDashboardApp extends StatelessWidget {
  const DriverMateDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => DashboardCubit(DashboardRepo())..load()),
        BlocProvider(create: (_) => CarsCubit(CarsRepo())..loadCars()),
        BlocProvider(
          create: (_) =>
              ServiceCentersCubit(ServiceCentersRepo())..loadCenters(),
        ),
        BlocProvider(create: (_) => TipsCubit(TipsRepo())..loadTips()),
        BlocProvider(create: (_) => UsersCubit(UsersRepo())..loadUsers()),
        BlocProvider(create: (_) => AdminsCubit(AdminsRepo())..loadAdmins()),
        BlocProvider(create: (_) => ReportsCubit(ReportsRepo())..loadReports()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Driver Mate Dashboard',
        theme: AppTheme.light,
        initialRoute: RouteNames.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
