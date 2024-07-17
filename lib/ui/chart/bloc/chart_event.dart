import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();
}

class LoadChartEvent extends ChartEvent {
  final int selectedYear;
  const LoadChartEvent(this.selectedYear);

  @override
  List<Object?> get props => [selectedYear];
}
