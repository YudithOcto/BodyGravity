import 'package:bodygravity/ui/chart/bloc/chart_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ChartState extends Equatable {
  const ChartState();
}

class InitialState extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartLoadingState extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartSuccessState extends ChartState {
  final List<TransactionSpec> data;
  final int currentYear;
  const ChartSuccessState(this.data, this.currentYear);
  @override
  List<Object?> get props => [data, currentYear];
}

class ChartFailedState extends ChartState {
  @override
  List<Object?> get props => [];
}
