import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/features/articls/view/article_view.dart';
import 'package:drive_mate_dash_board/features/auth/view/login_page.dart';
import 'package:drive_mate_dash_board/features/community/view/community_view.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/dashboard_page.dart';
import 'package:drive_mate_dash_board/core/widgets/generic_dashboard_page.dart';
import 'package:drive_mate_dash_board/core/routing/app_route_args.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/dataset/view/dataset_view.dart';
import 'package:drive_mate_dash_board/features/tips/view/tips_list_page.dart';
import 'package:drive_mate_dash_board/features/tips/view/tip_add_page.dart';
import 'package:drive_mate_dash_board/features/tips/view/tip_edit_page.dart';
import 'package:drive_mate_dash_board/features/service_centers/view/centers_list_page.dart';
import 'package:drive_mate_dash_board/features/service_centers/view/add_center_page.dart';
import 'package:drive_mate_dash_board/features/service_centers/view/edit_center_page.dart';
import 'package:drive_mate_dash_board/features/cars/view/cars_list_page.dart';
import 'package:drive_mate_dash_board/features/cars/view/add_car_page.dart';
import 'package:drive_mate_dash_board/features/cars/view/edit_car_page.dart';
import 'package:drive_mate_dash_board/features/users/view/users_list_page.dart';
import 'package:drive_mate_dash_board/features/admins/view/admins_list_page.dart';
import 'package:drive_mate_dash_board/features/reports/view/reports_list_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/activity_log_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/active_users_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/total_cars_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/revenue_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/pending_reviews_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/view/activity_details_page.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (ctx) => const DashboardPage());

      case RouteNames.activityLog:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return ActivityLogPage(adminType: adminType);
          },
        );

      case RouteNames.activityDetails:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            ActivityItemModel? activity;
            if (args is AppRouteArgs) {
              adminType = args.adminType;
            } else if (args is ActivityItemModel) {
              activity = args;
            } else if (args is Map && args.containsKey('activity')) {
              activity = args['activity'] as ActivityItemModel?;
            }
            return ActivityDetailsPage(
              adminType: adminType,
              activity: activity,
            );
          },
        );

      case RouteNames.activeUsers:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return ActiveUsersPage(adminType: adminType);
          },
        );

      case RouteNames.totalCars:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return TotalCarsPage(adminType: adminType);
          },
        );

      case RouteNames.revenue:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return RevenuePage(adminType: adminType);
          },
        );

      case RouteNames.pendingReviews:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return PendingReviewsPage(adminType: adminType);
          },
        );

      case RouteNames.cars:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return CarsListPage(adminType: adminType);
          },
        );

      case RouteNames.addCar:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return AddCarPage(adminType: adminType);
          },
        );

      case RouteNames.editCar:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            Object? carId;
            if (args is AppRouteArgs) {
              adminType = args.adminType;
            } else if (args is Map && args.containsKey('id')) {
              carId = args['id'];
            } else if (args is Map<String, Object?>) {
              carId = args['id'];
            }
            return EditCarPage(adminType: adminType, carId: carId);
          },
        );

      case RouteNames.serviceCenters:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return CentersListPage(adminType: adminType);
          },
        );

      case RouteNames.addCenter:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return AddCenterPage(adminType: adminType);
          },
        );

      case RouteNames.editCenter:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            Object? id;
            if (args is AppRouteArgs) {
              adminType = args.adminType;
            } else if (args is Map && args.containsKey('id')) {
              id = args['id'];
            } else if (args is Map<String, Object?>) {
              id = args['id'];
            }
            return EditCenterPage(adminType: adminType, centerId: id);
          },
        );

      case RouteNames.analytics:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return AnalyticsPage(adminType: adminType);
          },
        );

      case RouteNames.community:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return CommunityPage(adminType: adminType);
          },
        );

      case RouteNames.datasets:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return DatasetsPage(adminType: adminType);
          },
        );

      case RouteNames.tips:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return TipsListPage(adminType: adminType);
          },
        );

      case RouteNames.addTip:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return TipAddPage(adminType: adminType);
          },
        );

      case RouteNames.editTip:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            Object? id;
            if (args is AppRouteArgs) {
              adminType = args.adminType;
            } else if (args is Map && args.containsKey('id')) {
              id = args['id'];
            }
            return TipEditPage(adminType: adminType, itemId: id);
          },
        );

      case RouteNames.users:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return ManageUsersPage(adminType: adminType);
          },
        );

      case RouteNames.userDetails:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return GenericDashboardPage(
              title: 'User Details',
              selectedRoute: RouteNames.userDetails,
              adminType: adminType,
            );
          },
        );

      case RouteNames.admins:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return AdminsListPage(adminType: adminType);
          },
        );

      case RouteNames.reports:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return ReportsListPage(adminType: adminType);
          },
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (ctx) {
            final args = settings.arguments;
            AdminType adminType = AdminType.opsAdmin;
            if (args is AppRouteArgs) adminType = args.adminType;
            return GenericDashboardPage(
              title: 'Settings',
              selectedRoute: RouteNames.settings,
              adminType: adminType,
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for "${settings.name}"'),
            ),
          ),
        );
    }
  }
}
