import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class InitialSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class LoadedSearchState extends SearchState {
  final List<TransactionResponseDto> transactions;
  LoadedSearchState(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

class LoadingSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}

class FailedSearchState extends SearchState {
  final String message;
  FailedSearchState(this.message);
  @override
  List<Object?> get props => [message];
}
