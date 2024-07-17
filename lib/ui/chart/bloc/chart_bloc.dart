import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/chart/bloc/chart_event.dart';
import 'package:bodygravity/ui/chart/bloc/chart_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chartbloc extends Bloc<ChartEvent, ChartState> {
  final TransactionsRepository _transactionsRepository;
  Chartbloc(this._transactionsRepository) : super(InitialState()) {
    on<LoadChartEvent>((event, emit) async {
      emit(ChartLoadingState());
      final startDate = DateTime(event.selectedYear, 1, 1);
      final endDate = DateTime(event.selectedYear, 12, 31);
      final result = await _transactionsRepository.getTransactions(
          null,
          DateTimeUtil.convertToYMDFormatFromCurrentDate(startDate),
          DateTimeUtil.convertToYMDFormatFromCurrentDate(endDate),
          1,
          100);
      if (result.isSuccess == true) {
        emit(ChartSuccessState(aggregateByMonth(result.data ?? []), event.selectedYear));
      } else {
        emit(ChartFailedState());
      }
    });
  }
}

List<TransactionSpec> aggregateByMonth(List<TransactionResponseDto> transactions) {
  final List<TransactionSpec> convertedTransactions = [];
  for (var month in monthNames) {
    convertedTransactions.add(TransactionSpec(
        monthName: month, totalAccumulatedFee: 0.0, totalSession: 0));
  }

  for (var item in transactions) {
    final date = DateTime.parse(item.date);
    int monthIndex = date.month - 1; // Month is 1-indexed in DateTime

    final currentSpec = convertedTransactions[monthIndex];
    convertedTransactions[monthIndex] = currentSpec.copyWith(
      totalAccumulatedFee: currentSpec.totalAccumulatedFee + item.fee,
      totalSession: currentSpec.totalSession + item.sessions.length,
    );
  }

  return convertedTransactions;
  // Map<int, double> monthlyFees = {};

  // for (var transaction in transactions) {
  //   DateTime date = DateTime.parse(transaction.date);
  //   int month = date.month;
  //   if (monthlyFees.containsKey(month)) {
  //     monthlyFees[month] = monthlyFees[month] ?? 0.0 + transaction.fee;
  //   } else {
  //     monthlyFees[month] = transaction.fee.toDouble();
  //   }
  // }

  // return monthlyFees;
}

const List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class TransactionSpec extends Equatable {
  final String monthName;
  final int totalSession;
  final double totalAccumulatedFee;
  const TransactionSpec(
      {required this.monthName,
      required this.totalAccumulatedFee,
      required this.totalSession});

  @override
  List<Object?> get props => [monthName, totalAccumulatedFee, totalSession];

  TransactionSpec copyWith({
    String? monthName,
    double? totalAccumulatedFee,
    int? totalSession,
  }) {
    return TransactionSpec(
      monthName: monthName ?? this.monthName,
      totalAccumulatedFee: totalAccumulatedFee ?? this.totalAccumulatedFee,
      totalSession: totalSession ?? this.totalSession,
    );
  }
}
