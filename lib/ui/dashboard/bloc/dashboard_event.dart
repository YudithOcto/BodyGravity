import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class LoadDataEvent extends DashboardEvent {
  @override
  List<Object?> get props => [];
}