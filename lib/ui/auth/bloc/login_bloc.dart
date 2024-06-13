import 'package:bodygravity/data/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<SubmitEmailEvent>((event, emit) async {
      emit(LoginLoading());

      if (_isValidEmail(event.email)) {
        final result = await authRepository.sendOtp(event.email);
        if (result.isSuccess == true) {
          emit(SendOtpSuccess());
        } else {
          emit(SendOtpFailed(result.message ?? "Telah Terjadi Kesalahan"));
        }
      } else {
        emit(const SendOtpFailed("Email tidak valid. Silahkan masukkan lagi"));
      }
    });

    on<SubmitOtpEvent>((event, emit) async {
      emit(LoginLoading());

      final result = await authRepository.login(event.email, event.otp);
      if (result.isSuccess == true) {
        add(SaveBearerTokenEvent(
            result.data?.token ?? "", result.message ?? "Sukses Login"));
      } else {
        emit(LoginFailure(result.message ?? "Telah Terjadi Kesalahan"));
      }
    });

    on<SaveBearerTokenEvent>((event, emit) async {
      await authRepository.saveBearerToken(event.token);
      emit(LoginSuccess(event.message));
    });

    on<TimerEndedEvent>((event, emit) {
      emit(const ShowResendTextState());
    });

    on<StartTimerEvent>((event, emit) {
      emit(const ShowTimerState(60));
    });

    on<RestartTimerEvent>((event, emit) async {
      final result = await authRepository.sendOtp(event.email);
      if (result.isSuccess == true) {
        emit(const ShowTimerState(60));
      } else {
        emit(SendOtpFailed(result.message ?? "Telah Terjadi Kesalahan"));
      }
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }
}
