import 'package:drive_mate_dash_board/features/service_centers/data/model/service_center_model.dart';

sealed class ServiceCentersState {}

class ServiceCentersInitial extends ServiceCentersState {}

class ServiceCentersLoading extends ServiceCentersState {}

class ServiceCentersSuccess extends ServiceCentersState {
  ServiceCentersSuccess(this.centers);

  final List<ServiceCenterModel> centers;
}

class ServiceCentersError extends ServiceCentersState {
  ServiceCentersError(this.message);

  final String message;
}
