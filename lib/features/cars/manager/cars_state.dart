import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';

sealed class CarsState {}

class CarsInitial extends CarsState {}

class CarsLoading extends CarsState {}

class CarsSuccess extends CarsState {
  CarsSuccess(this.cars);

  final List<CarModel> cars;
}

class CarsError extends CarsState {
  CarsError(this.message);

  final String message;
}
