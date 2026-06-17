import 'package:drive_mate_dash_board/features/tips/data/model/tip_model.dart';

sealed class TipsState {}

class TipsInitial extends TipsState {}

class TipsLoading extends TipsState {}

class TipsSuccess extends TipsState {
  TipsSuccess(this.tips);

  final List<TipModel> tips;
}

class TipsError extends TipsState {
  TipsError(this.message);

  final String message;
}
