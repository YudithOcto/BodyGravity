import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final String message;

  const LoginSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SendOtpSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class SendOtpFailed extends LoginState {
  final String error;

  const SendOtpFailed(this.error);

  @override
  List<Object> get props => [error];
}

class ShowTimerState extends LoginState {
  final int remainingSeconds;
  const ShowTimerState(this.remainingSeconds);
  @override
  List<Object?> get props => [];
}

class ShowResendTextState extends LoginState {
  const ShowResendTextState();
  @override
  List<Object?> get props => [];
}
