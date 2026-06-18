import 'package:drive_mate_dash_board/features/admins/data/model/admin_model.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/activity_item_model.dart';
import 'package:drive_mate_dash_board/features/dashboard/data/model/dashboard_metric_model.dart';
import 'package:drive_mate_dash_board/features/reports/data/model/report_model.dart';
import 'package:drive_mate_dash_board/features/service_centers/data/model/service_center_model.dart';
import 'package:drive_mate_dash_board/features/tips/data/model/tip_model.dart';

sealed class MockData {
  static const dashboardMetrics = [
    DashboardMetricModel(
      title: 'Active Users',
      value: '1,234',
      delta: '+12%',
      iconName: 'users',
    ),
    DashboardMetricModel(
      title: 'Total Cars',
      value: '432',
      delta: '+5%',
      iconName: 'pulse',
    ),
    DashboardMetricModel(
      title: 'Revenue',
      value: r'$45k',
      delta: '+18%',
      iconName: 'trend',
    ),
    DashboardMetricModel(
      title: 'Pending Reviews',
      value: '12',
      delta: '-2%',
      iconName: 'grid',
    ),
  ];

  static const activities = [
    ActivityItemModel(
      title: 'New car model added',
      subtitle: 'Toyota Camry 2024',
      actor: 'Admin User',
      time: '2 hours ago',
      type: 'Cars',
    ),
    ActivityItemModel(
      title: 'Post flagged',
      subtitle: 'Report ID #9921',
      actor: 'Mod Bot',
      time: '4 hours ago',
      type: 'Community',
    ),
    ActivityItemModel(
      title: 'Status changed',
      subtitle: 'Sharjah Center',
      actor: 'Ops Manager',
      time: 'Yesterday',
      type: 'Centers',
    ),
    ActivityItemModel(
      title: 'Dataset updated',
      subtitle: 'Maintenance Prices v2.1',
      actor: 'Super Admin',
      time: 'Yesterday',
      type: 'Datasets',
    ),
    ActivityItemModel(
      title: 'Price updated',
      subtitle: 'Nissan Patrol',
      actor: 'Admin User',
      time: '2 days ago',
      type: 'Cars',
    ),
    ActivityItemModel(
      title: 'User banned',
      subtitle: 'Spammer_007',
      actor: 'Community Mod',
      time: '2 days ago',
      type: 'Users',
    ),
  ];

  static const cars = [
    CarModel(
      name: 'Toyota Camry 2024',
      brand: 'Toyota',
      model: 'Camry',
      year: 2024,
      status: 'Published',
      condition: 'Used',
      price: r'$28,000',
      description: 'Sedan - 2.5L Hybrid',
    ),
    CarModel(
      name: 'Honda Civic 2023',
      brand: 'Honda',
      model: 'Civic',
      year: 2023,
      status: 'Draft',
      condition: 'Used',
      price: r'$24,500',
      description: 'Sedan - 2.5L Hybrid',
    ),
    CarModel(
      name: 'Ford Mustang 2023',
      brand: 'Ford',
      model: 'Mustang',
      year: 2023,
      status: 'Sold',
      condition: 'Used',
      price: r'$45,000',
      description: 'Coupe - 5.0L V8',
    ),
    CarModel(
      name: 'BMW 3 Series 2024',
      brand: 'BMW',
      model: '3 Series',
      year: 2024,
      status: 'Published',
      condition: 'New',
      price: r'$52,000',
      description: 'Sedan - 2.0L Turbo',
    ),
  ];

  static const centers = [
    ServiceCenterModel(
      name: 'Dubai Main Workshop',
      city: 'Dubai',
      location: 'Al Quoz Industrial Area 3',
      phone: '+971 50 123 4567',
      status: 'Operational',
      services: 'Oil Change, Tires, Engine',
    ),
    ServiceCenterModel(
      name: 'Abu Dhabi Service Point',
      city: 'Abu Dhabi',
      location: 'Mussafah M9',
      phone: '+971 50 555 4567',
      status: 'Operational',
      services: 'AC Repair, Diagnostics',
    ),
    ServiceCenterModel(
      name: 'Sharjah Quick Fix',
      city: 'Sharjah',
      location: 'Industrial Area 6',
      phone: '+971 50 777 4567',
      status: 'Closed',
      services: 'Oil Change, Battery',
    ),
  ];

  static const tips = [
    TipModel(
      title: 'Emergency Kit Essentials (Vol. 2)',
      category: 'Driving Tips',
      status: 'Published',
      date: '6/17/2026',
      views: 2940,
      likes: 60,
      difficulty: 'Medium',
      duration: '36 mins',
    ),
    TipModel(
      title: 'Coolant Level Check (Vol. 2)',
      category: 'Fuel Efficiency',
      status: 'Published',
      date: '6/16/2026',
      views: 4129,
      likes: 473,
      difficulty: 'Hard',
      duration: '31 mins',
    ),
    TipModel(
      title: 'Jump Starting a Car (Vol. 2)',
      category: 'Safety',
      status: 'Published',
      date: '6/15/2026',
      views: 1449,
      likes: 373,
      difficulty: 'Easy',
      duration: '7 mins',
    ),
    TipModel(
      title: 'How to Change Your Oil (Vol. 2)',
      category: 'DIY Repairs',
      status: 'Draft',
      date: '6/14/2026',
      views: 706,
      likes: 51,
      difficulty: 'Easy',
      duration: '38 mins',
    ),
  ];

  static const admins = [
    AdminModel(
      name: 'Super Admin',
      email: 'super@dm.com',
      role: AdminType.superAdmin,
      status: 'Active',
    ),
    AdminModel(
      name: 'Ops Manager',
      email: 'ops@dm.com',
      role: AdminType.opsAdmin,
      status: 'Active',
    ),
    AdminModel(
      name: 'Community Mod',
      email: 'community@dm.com',
      role: AdminType.communityAdmin,
      status: 'Active',
    ),
  ];

  static const reports = [
    ReportModel(
      id: 'RPT-9921',
      user: 'user123',
      type: 'Post Report',
      date: '2h ago',
      status: 'Pending',
      priority: 'High',
      title: 'Inappropriate Content',
    ),
    ReportModel(
      id: 'RPT-9922',
      user: 'seller_dxb',
      type: 'Car Listing',
      date: '5h ago',
      status: 'Pending',
      priority: 'Medium',
      title: 'Fake Details Suspected',
    ),
    ReportModel(
      id: 'RPT-9923',
      user: 'bot_99',
      type: 'Comment',
      date: '1d ago',
      status: 'Open',
      priority: 'Low',
      title: 'Spam Link',
    ),
  ];
}
