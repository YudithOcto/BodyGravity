import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SubmitEmailEvent extends LoginEvent {
  final String email;

  const SubmitEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class SubmitOtpEvent extends LoginEvent {
  final String email;
  final String otp;

  const SubmitOtpEvent(this.email, this.otp);

  @override
  List<Object?> get props => [email, otp];
}

class SaveBearerTokenEvent extends LoginEvent {
  final String token;
  final String message;

  const SaveBearerTokenEvent(this.token, this.message);

  @override
  List<Object?> get props => [token, message];
}

class StartTimerEvent extends LoginEvent {
  const StartTimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerEndedEvent extends LoginEvent {
  const TimerEndedEvent();
  @override
  List<Object?> get props => [];
}

class RestartTimerEvent extends LoginEvent {
  final String email;
  const RestartTimerEvent(this.email);
  @override
  List<Object?> get props => [email];
}
