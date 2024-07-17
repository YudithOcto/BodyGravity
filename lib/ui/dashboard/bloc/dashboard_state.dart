import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/data/transactions/model/dashboard_performance_dto.dart';
import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:bodygravity/data/transactions/model/workout_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitialState extends DashboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoadingState extends DashboardState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends DashboardState {
  final String message;
  const ErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class LoadedState extends DashboardState {
  final ProfileResponseDto profileData;
  final DashboardPerformanceDto? dashboardData;
  final List<TransactionResponseDto> latestTransactions;
  final List<WorkoutResponseDto> nextSessions;
  final bool isUpdating;
  final String? errorMessage;
  final bool isShowChart;
  const LoadedState(
      this.profileData,
      this.dashboardData,
      this.latestTransactions,
      this.nextSessions,
      this.isUpdating,
      this.errorMessage, this.isShowChart);

  LoadedState copyWith({
    bool? isUpdating,
    String? errorMessage,
    bool? isShowChart,
  }) {
    return LoadedState(
      profileData,
      dashboardData,
      latestTransactions,
      nextSessions,
      isUpdating ?? this.isUpdating,
      errorMessage ?? this.errorMessage,
      isShowChart ?? this.isShowChart,
    );
  }

  @override
  List<Object?> get props => [
        profileData,
        dashboardData,
        latestTransactions,
        nextSessions,
        isUpdating,
        errorMessage,
        isShowChart
      ];
}

class UpdateWorkoutEventLoadingState extends DashboardState {
  @override
  List<Object?> get props => [];
}

class OpeningChartState extends DashboardState {
  final List<ChartData> data;
  const OpeningChartState(this.data);
  @override
  List<Object?> get props => [data];
}

class ChartData {
  ChartData(this.date, this.fee);
  final String date;
  final num fee;
}
