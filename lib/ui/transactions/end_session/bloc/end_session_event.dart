import 'package:equatable/equatable.dart';

abstract class EndSessionEvent extends Equatable {
  const EndSessionEvent();
}

class StartTimerEvent extends EndSessionEvent {
  const StartTimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerEndedEvent extends EndSessionEvent {
  const TimerEndedEvent();
  @override
  List<Object?> get props => [];
}

class RestartTimerEvent extends EndSessionEvent {
  final String workoutId;
  const RestartTimerEvent(this.workoutId);
  @override
  List<Object?> get props => [workoutId];
}

class SubmitDataEvent extends EndSessionEvent {
  final String workoutId;
  final String otp;

  const SubmitDataEvent(this.workoutId, this.otp);
  @override
  List<Object?> get props => [workoutId, otp];
}

class InitialEndSessionEvent extends EndSessionEvent {
  final String workoutId;
  const InitialEndSessionEvent(this.workoutId);
  @override
  List<Object?> get props => [workoutId];
}
