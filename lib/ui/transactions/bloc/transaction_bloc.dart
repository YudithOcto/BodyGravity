import 'package:bodygravity/common/extension.dart';
import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/data/transactions/model/package_response_dto.dart';
import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_event.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionsRepository _transactionsRepository;

  TransactionBloc(this._transactionsRepository)
      : super(InitialTransactionState()) {
    on<LoadPackagetEvent>((event, emit) async {
      emit(TransactionLoadingState());
      final result = await _transactionsRepository.getTransactionPackage();
      if (result.isSuccess == true) {
        final transactions = result.data ?? [];
        if (event.userRole == Role.admin) {
          transactions.add(PackageResponseDto(
              id: "",
              name: "",
              price: 0,
              session: 0,
              expiredInMonth: 3,
              isRoleAdmin: true));
        }
        emit(LoadedAddTransactionState(transactions, null, null, null));
      } else {
        emit(FailedPackageState(result.message ?? "Terjadi Kesalahan"));
      }
    });
    on<SelectedClientEvent>((event, emit) {
      final data = state as LoadedAddTransactionState;
      emit(LoadedAddTransactionState(
          data.packages, data.activeIndex, data.selectedPackage, event.user));
    });
    on<SelectedPackageEvent>((event, emit) {
      final data = state as LoadedAddTransactionState;
      emit(LoadedAddTransactionState(
          data.packages, event.activeIndex, event.data, data.user));
    });
    on<AddTransactionEvent>((event, emit) async {
      final currentState = state;
      emit(TransactionLoadingState());
      final result = await _transactionsRepository.createOrder(
          event.userId, event.packageId);
      if (result.isSuccess == true) {
        emit(AddTransactionSuccessState(result.message.isNotNullOrEmpty
            ? result.message!
            : "Sukses buat transaksi"));
      } else {
        emit(FailedAddTransactionState(
            result.message ?? "Telah Terjadi Kesalahan"));
        emit(currentState);
      }
    });
  }
}
