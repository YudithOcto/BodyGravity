import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:bodygravity/data/transactions/transactions_repository.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_event.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final TransactionsRepository _transactionsRepository;
  SearchBloc(this._transactionsRepository) : super(InitialSearchState()) {
    on<LoadSearchEvent>((event, emit) async {
      emit(LoadingSearchState());
      final result = await _transactionsRepository.getTransactions(
          event.query, null, null, 1, 10);
      if (result.isSuccess == true) {
        List<TransactionResponseDto> flattenedSessions = result.data!
        .expand((wrapper) => wrapper.sessions.map((session) => TransactionResponseDto(
              date: wrapper.date,
              sessions: [TransactionSessionDto(customerName: session.customerName, trainerFee: session.trainerFee)], // Assuming each session is considered as 1 unit
              fee: session.trainerFee,
            )))
        .toList();
        emit(LoadedSearchState(flattenedSessions));
      } else {
        emit(FailedSearchState(result.message ?? "Telah terjadi Kesalahn"));
      }
    });
    on<InitialLoadEvent>((event, emit) async {
      emit(InitialSearchState());
    });
  }
}
