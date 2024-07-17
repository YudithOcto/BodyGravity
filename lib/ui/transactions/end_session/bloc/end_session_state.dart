import 'package:equatable/equatable.dart';

abstract class EndSessionState extends Equatable {
  const EndSessionState();
}

class InitialState extends EndSessionState {
  @override
  List<Object?> get props => [];
}

class OtpShowTimerState extends EndSessionState {
  final int remainingSeconds;
  const OtpShowTimerState(this.remainingSeconds);
  @override
  List<Object?> get props => [];
}

class OtpShowResendTextState extends EndSessionState {
  const OtpShowResendTextState();
  @override
  List<Object?> get props => [];
}

class SendOtpFailedState extends EndSessionState {
  final String message;
  const SendOtpFailedState(this.message);
  @override
  List<Object?> get props => [message];
}

class SubmitDataSuccessState extends EndSessionState {
  final String message;
  const SubmitDataSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class SubmitDataFailedState extends EndSessionState {
  final String message;
  const SubmitDataFailedState(this.message);
  @override
  List<Object?> get props => [message];
}

class EndSessionLoading extends EndSessionState {
  @override
  List<Object?> get props => [];
}