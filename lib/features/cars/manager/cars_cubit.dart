import 'package:drive_mate_dash_board/features/cars/data/cars_repo.dart';
import 'package:drive_mate_dash_board/features/cars/manager/cars_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarsCubit extends Cubit<CarsState> {
  CarsCubit(this.repo) : super(CarsInitial());

  final CarsRepo repo;

  Future<void> loadCars() async {
    emit(CarsLoading());
    final response = await repo.getCars();
    if (response.success && response.data != null) {
      emit(CarsSuccess(response.data!));
    } else {
      emit(CarsError(response.message));
    }
  }
}
