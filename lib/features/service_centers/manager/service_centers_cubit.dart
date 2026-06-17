import 'package:drive_mate_dash_board/features/service_centers/data/service_centers_repo.dart';
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCentersCubit extends Cubit<ServiceCentersState> {
  ServiceCentersCubit(this.repo) : super(ServiceCentersInitial());

  final ServiceCentersRepo repo;

  Future<void> loadCenters() async {
    emit(ServiceCentersLoading());
    final response = await repo.getCenters();
    if (response.success && response.data != null) {
      emit(ServiceCentersSuccess(response.data!));
    } else {
      emit(ServiceCentersError(response.message));
    }
  }
}
