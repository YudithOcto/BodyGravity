import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/data/auth/auth_repository.dart';
import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_event.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthRepository authRepository;
  final TransactionsRepository _transactionsRepository;
  LoadedState? _loadedState;
  String? previousDate;
  String? currentDate =
      DateTimeUtil.convertToYMDFormatFromCurrentDate(DateTime.now());

  DashboardBloc(this.authRepository, this._transactionsRepository)
      : super(DashboardInitialState()) {
    on<LoadDataEvent>((event, emit) async {
      emit(DashboardLoadingState());
      final profileResult = await authRepository.getProfile();
      final dashboardResult =
          await _transactionsRepository.getDashboardPerformance();

      final transactions = await _transactionsRepository.getTransactions(
          "", previousDate, currentDate, 1, 10);
      final nextWorkoutSessions =
          await _transactionsRepository.getWorkoutList();

      if (profileResult.isSuccess == false &&
          dashboardResult.isSuccess == false &&
          transactions.isSuccess == false &&
          nextWorkoutSessions.isSuccess == false) {
        emit(ErrorState(
            message: profileResult.message ??
                "Telah Terjadi Kesalahan. Silahkan coba lagi."));
      } else {
        _loadedState = LoadedState(
            profileResult.data!,
            dashboardResult.data,
            transactions.data ?? [],
            nextWorkoutSessions.data ?? [],
            false,
            null,
            false);
        emit(_loadedState!);
      }
    });

    on<UpdateDateFilter>((event, emit) async {
      previousDate =
          DateTimeUtil.convertToYMDFormatFromCurrentDate(event.start);
      currentDate = DateTimeUtil.convertToYMDFormatFromCurrentDate(event.end);
      add(LoadDataEvent());
    });

    on<UpdateTransactionViewTypeEvent>((event, emit) {
      final loadState = _loadedState;
      _loadedState = loadState?.copyWith(isShowChart: event.isShowChart);
      emit(_loadedState!);
    });

    on<CancelWorkoutEvent>((event, emit) async {
      emit(_loadedState!.copyWith(isUpdating: true));
      final result =
          await _transactionsRepository.cancelWorkout(event.workoutId);
      if (result.isSuccess == true) {
        add(LoadDataEvent());
      } else {
        emit(_loadedState!.copyWith(
            isUpdating: false,
            errorMessage: result.message ?? "Telah Terjadi Kesalahan"));
      }
    });
  }
}
