import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:equatable/equatable.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
}

class InitialLoadState extends CustomerState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends CustomerState {
  @override
  List<Object?> get props => [];
}

class LoadSuccessState extends CustomerState {
  final List<CustomerResponseDto> customers;
  const LoadSuccessState(this.customers);
  @override
  List<Object?> get props => [customers];
}

class LoadFailedState extends CustomerState {
  final String message;
  const LoadFailedState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddCustomerFailedState extends CustomerState {
  final String message;

  const AddCustomerFailedState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddCustomerSuccessState extends CustomerState {
  final String message;
  const AddCustomerSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
