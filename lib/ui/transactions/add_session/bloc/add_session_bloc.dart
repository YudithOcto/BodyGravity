import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_event.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSessionBloc extends Bloc<AddSessionEvent, AddSessionState> {
  final TransactionsRepository _transactionsRepository;
  AddSessionBloc(this._transactionsRepository)
      : super(const AddSessionFormDataState()) {
    on<InitAddSessionEvent>((event, emit) {
      emit(const AddSessionFormDataState());
    });
    on<UpdateCustomerEvent>((event, emit) {
      final currentState = state as AddSessionFormDataState;
      emit(currentState.copyWith(selectedCustomer: event.user));
    });
    on<UpdateDateEvent>((event, emit) {
      final currentState = state as AddSessionFormDataState;
      emit(currentState.copyWith(selectedDate: event.date));
    });
    on<UpdateTimeEvent>((event, emit) {
      final currentState = state as AddSessionFormDataState;
      emit(currentState.copyWith(selectedTime: event.time));
    });
    on<UpdateConcernEvent>((event, emit) {
      final currentState = state as AddSessionFormDataState;
      emit(currentState.copyWith(concern: event.concern));
    });
    on<SubmitDataEvent>((event, emit) async {
      final currentState = state as AddSessionFormDataState;
      emit(AddSessionLoadingState());
      final dateToApi = DateTimeUtil.formatScheduledAt(
          currentState.selectedDate!, currentState.selectedTime!);
      final result = await _transactionsRepository.createWorkout(
          currentState.selectedCustomer!.userId,
          currentState.concern ?? "",
          dateToApi);
      if (result.isSuccess == true) {
        emit(SubmitSuccessState(result.message ?? "Sukses Submit Data"));
      } else {
        emit(SubmitFailedState(
            result.message ?? "Telah Terjadi Kesalahan. Silahkan Coba lagi"));
        emit(currentState);
      }
    });
  }
}
