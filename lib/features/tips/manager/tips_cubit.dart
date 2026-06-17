import 'package:drive_mate_dash_board/features/tips/data/tips_repo.dart';
import 'package:drive_mate_dash_board/features/tips/manager/tips_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TipsCubit extends Cubit<TipsState> {
  TipsCubit(this.repo) : super(TipsInitial());

  final TipsRepo repo;

  Future<void> loadTips() async {
    emit(TipsLoading());
    final response = await repo.getTips();
    if (response.success && response.data != null) {
      emit(TipsSuccess(response.data!));
    } else {
      emit(TipsError(response.message));
    }
  }
}
