import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:bodygravity/data/transactions/model/package_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class LoadPackagetEvent extends TransactionEvent {
  final Role userRole;
  const LoadPackagetEvent(this.userRole);
  @override
  List<Object?> get props => [userRole];
}

class AddTransactionEvent extends TransactionEvent {
  final String userId;
  final String packageId;

  const AddTransactionEvent(this.userId, this.packageId);
  @override
  List<Object?> get props => [userId, packageId];
}

class SelectedClientEvent extends TransactionEvent {
  final CustomerResponseDto user;
  const SelectedClientEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class SelectedPackageEvent extends TransactionEvent {
  final PackageResponseDto data;
  final int activeIndex;
  const SelectedPackageEvent(this.data, this.activeIndex);

  @override
  List<Object?> get props => [data, activeIndex];
}
