import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitialState extends DashboardState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends DashboardState {
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
  const LoadedState(this.profileData);

  @override
  List<Object?> get props => [profileData];
}
