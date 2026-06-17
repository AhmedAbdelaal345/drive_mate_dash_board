import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/cars/data/model/car_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class CarsRepo {
  Future<ApiResponse<List<CarModel>>> getCars() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.cars);
  }
}
