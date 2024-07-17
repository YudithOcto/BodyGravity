import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AddSessionState extends Equatable {
  const AddSessionState();
}

class AddSessionLoadingState extends AddSessionState {
  @override
  List<Object?> get props => [];
}

class AddSessionFormDataState extends AddSessionState {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final CustomerResponseDto? selectedCustomer;
  final String? concern;

  const AddSessionFormDataState({
    this.selectedDate,
    this.selectedTime,
    this.selectedCustomer,
    this.concern,
  });

  AddSessionFormDataState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    CustomerResponseDto? selectedCustomer,
    String? concern,
  }) {
    return AddSessionFormDataState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      concern: concern ?? this.concern,
    );
  }

  @override
  List<Object?> get props =>
      [selectedCustomer, selectedDate, selectedTime, concern];
}

class SubmitFailedState extends AddSessionState {
  final String message;
  const SubmitFailedState(this.message);
  @override
  List<Object?> get props => [message];
}

class SubmitSuccessState extends AddSessionState {
  final String message;
  const SubmitSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}