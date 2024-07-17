import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_event.dart';
import 'package:bodygravity/ui/transactions/end_session/bloc/end_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndSessionBloc extends Bloc<EndSessionEvent, EndSessionState> {
  final TransactionsRepository _transactionsRepository;
  EndSessionBloc(this._transactionsRepository) : super(InitialState()) {
    on<InitialEndSessionEvent>((event, emit) async {
      final result =
          await _transactionsRepository.sendWorkoutFinishedOtp(event.workoutId);
      if (result.isSuccess == true) {
        emit(const OtpShowTimerState(60));
      } else {
        emit(SendOtpFailedState(result.message ?? "Telah Terjadi Kesalahan"));
      }
    });
    on<TimerEndedEvent>((event, emit) {
      emit(const OtpShowResendTextState());
    });

    on<StartTimerEvent>((event, emit) {
      emit(const OtpShowTimerState(60));
    });

    on<RestartTimerEvent>((event, emit) async {
      final result =
          await _transactionsRepository.sendWorkoutFinishedOtp(event.workoutId);
      if (result.isSuccess == true) {
        emit(const OtpShowTimerState(60));
      } else {
        emit(SendOtpFailedState(result.message ?? "Telah Terjadi Kesalahan"));
      }
    });
    on<SubmitDataEvent>((event, emit) async {
      emit(EndSessionLoading());
      final result = await _transactionsRepository.updateWorkout(
          event.workoutId, event.otp);
      if (result.isSuccess == true) {
        emit(SubmitDataSuccessState(result.message ?? "Sukses Update Data"));
      } else {
        emit(SubmitDataFailedState(result.message ?? "Sukses Update Data"));
      }
    });
  }
}
