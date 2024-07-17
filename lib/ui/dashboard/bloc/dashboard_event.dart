import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class LoadDataEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}

class UpdateDateFilter extends DashboardEvent {
  final DateTime start;
  final DateTime end;
  const UpdateDateFilter(this.start, this.end);
  @override
  List<Object?> get props => [start, end];
}

class UpdateTransactionViewTypeEvent extends DashboardEvent {
  final bool isShowChart;
  const UpdateTransactionViewTypeEvent(this.isShowChart);
  @override
  List<Object?> get props => [isShowChart];
}

class CancelWorkoutEvent extends DashboardEvent {
  final String workoutId;
  const CancelWorkoutEvent(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}
