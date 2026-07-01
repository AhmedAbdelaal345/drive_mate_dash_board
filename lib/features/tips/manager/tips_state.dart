import 'package:drive_mate_dash_board/features/tips/data/model/tip_model.dart';

sealed class TipsState {
  const TipsState();
}

class TipsInitial extends TipsState {
  const TipsInitial();
}

class TipsLoading extends TipsState {
  const TipsLoading();
}

class TipsSuccess extends TipsState {
  const TipsSuccess(this.tips);

  final List<TipModel> tips;
}

class TipCreateSuccess extends TipsState {
  const TipCreateSuccess(this.message);
  final String message;
}

class TipsError extends TipsState {
  const TipsError(this.message);

  final String message;
}
