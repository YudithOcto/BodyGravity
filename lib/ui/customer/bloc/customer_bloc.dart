import 'package:bodygravity/data/customer/customer_repository.dart';
import 'package:bodygravity/ui/customer/bloc/customer_event.dart';
import 'package:bodygravity/ui/customer/bloc/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  CustomerBloc(this.customerRepository) : super(InitialLoadState()) {
    on<LoadDataEvent>((event, emit) async {
      emit(LoadingState());
      final result = await customerRepository.getCustomerList(
          event.query, event.page ?? 1);
      if (result.isSuccess == true) {
        emit(LoadSuccessState(result.data!));
      } else {
        emit(LoadFailedState(result.message ?? "telah terjadi kesalahan."));
      }
    });

    on<AddCustomerEvent>((event, emit) async {
      emit(LoadingState());

      final result = await customerRepository.addCustomer(
          event.email, event.phoneNumber, event.name);

      if (result.isSuccess == true) {
        add(const LoadDataEvent("", 1));
      } else {
        emit(AddCustomerFailedState(
            result.message ?? "telah terjadi kesalahan. Silahkan coba lagi"));
      }
    });
  }
}
