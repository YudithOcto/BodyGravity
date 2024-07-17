import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:bodygravity/data/transactions/model/package_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class InitialTransactionState extends TransactionState {
  @override
  List<Object?> get props => [];
}

class TransactionLoadingState extends TransactionState {
  @override
  List<Object?> get props => [];
}

class LoadedAddTransactionState extends TransactionState {
  final List<PackageResponseDto> packages;
  final int? activeIndex;
  final PackageResponseDto? selectedPackage;
  final CustomerResponseDto? user;
  const LoadedAddTransactionState(
    this.packages,
    this.activeIndex,
    this.selectedPackage,
    this.user,
  );
  @override
  List<Object?> get props => [packages, activeIndex, selectedPackage, user];
}

class FailedPackageState extends TransactionState {
  final String message;
  const FailedPackageState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddTransactionSuccessState extends TransactionState {
  final String message;
  const AddTransactionSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class FailedAddTransactionState extends TransactionState {
  final String message;
  const FailedAddTransactionState(this.message);
  @override
  List<Object?> get props => [message];
}