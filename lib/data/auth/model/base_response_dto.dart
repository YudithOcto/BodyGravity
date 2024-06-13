import 'package:equatable/equatable.dart';

class BaseResponseDto<T> extends Equatable {
  final bool? isSuccess;
  final String? message;
  final T? data;

  const BaseResponseDto({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory BaseResponseDto.fromJson(
      Map<String, dynamic> json, T Function(Object? json)? fromJsonT) {
    return BaseResponseDto(
      isSuccess: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [isSuccess, message, data];
}
