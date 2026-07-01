import 'package:drive_mate_dash_board/features/cars/data/cars_repo.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarsCubit extends Cubit<CarsState> {
  CarsCubit(this.repo) : super(CarsInitial());

  final CarsRepo repo;

  Future<void> loadCars({String searchTerm = ''}) async {
    emit(CarsLoading());
    final response = await repo.getCars(searchTerm: searchTerm);
    if (response.data != null && response.data is List) {
      final cars = (response.data as List)
          .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(CarsSuccess(cars));
    } else {
      emit(CarsError(response.message));
    }
  }

  Future<bool> createCar(CreateCarRequest request) async {
    final response = await repo.createCar(request);
    if (response.status == true) {
      await loadCars();
      return true;
    }
    emit(CarsError(response.message));
    return false;
  }

  Future<bool> updateCar({
    required int id,
    required UpdateCarRequest request,
  }) async {
    final response = await repo.updateCar(id: id, request: request);
    if (response.status == true) {
      await loadCars();
      return true;
    }
    emit(CarsError(response.message));
    return false;
  }
}
