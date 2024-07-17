import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}
class CustomerInitialLoadEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}
class LoadDataEvent extends CustomerEvent {
  final String? query;
  final int? page;

  const LoadDataEvent(this.query, this.page);

  @override
  List<Object?> get props => [query, page];
}

class AddCustomerEvent extends CustomerEvent {
  final String phoneNumber;
  final String email;
  final String name;

  const AddCustomerEvent(this.phoneNumber, this.email, this.name);

  @override
  List<Object?> get props => [phoneNumber, name, email];
}

class ClearDataEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}
