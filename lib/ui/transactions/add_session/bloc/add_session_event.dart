import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AddSessionEvent extends Equatable {}

class InitAddSessionEvent extends AddSessionEvent {
  @override
  List<Object?> get props => [];
}


class UpdateCustomerEvent extends AddSessionEvent {
  final CustomerResponseDto user;
  UpdateCustomerEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateTimeEvent extends AddSessionEvent {
  final TimeOfDay time;
  UpdateTimeEvent(this.time);
  @override
  List<Object?> get props => [time];
}

class UpdateDateEvent extends AddSessionEvent {
  final DateTime date;
  UpdateDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class UpdateConcernEvent extends AddSessionEvent {
  final String concern;
  UpdateConcernEvent(this.concern);

  @override
  List<Object?> get props => [concern];
}

class SubmitDataEvent extends AddSessionEvent {
  @override
  List<Object?> get props => [];
}