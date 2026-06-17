import 'package:drive_mate_dash_board/core/models/api_response.dart';
import 'package:drive_mate_dash_board/features/tips/data/model/tip_model.dart';
import 'package:drive_mate_dash_board/shared/mock_data.dart';

class TipsRepo {
  Future<ApiResponse<List<TipModel>>> getTips() async {
    // TODO: Implement API Integration
    return ApiResponse.success(MockData.tips);
  }
}
