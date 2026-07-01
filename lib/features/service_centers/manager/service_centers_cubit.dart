import 'package:drive_mate_dash_board/features/service_centers/data/service_centers_repo.dart';
import 'package:drive_mate_dash_board/features/service_centers/manager/service_centers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCentersCubit extends Cubit<ServiceCentersState> {
  ServiceCentersCubit(this.repo) : super(ServiceCentersInitial());

  final ServiceCentersRepo repo;

  String _query = '';
  int _page = 1;

  Future<void> loadCenters({String searchTerm = '', int page = 1}) async {
    _query = searchTerm;
    _page = page;
    emit(ServiceCentersLoading());
    try {
      final response = await repo.getCenters(
        pageNumber: _page,
        searchTerm: _query,
      );
      emit(ServiceCentersSuccess(response));
    } catch (e) {
      emit(ServiceCentersError(e.toString()));
    }
  }

  Future<bool> createCenter({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String phone,
  }) async {
    try {
      final response = await repo.createCenter(
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
      );
      if (response.status == true) {
        await loadCenters(searchTerm: _query, page: _page);
        return true;
      }
      emit(ServiceCentersError(response.message));
      return false;
    } catch (e) {
      emit(ServiceCentersError(e.toString()));
      return false;
    }
  }
}
