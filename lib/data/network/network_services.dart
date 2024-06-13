import 'package:bodygravity/data/auth/model/base_response_dto.dart';

abstract class NetworkService {
  Future<BaseResponseDto<T>> get<T>(String url, T Function(Object? json)? fromJsonT, {Map<String, dynamic>? queryParameters});
  Future<BaseResponseDto<T>> post<T>(String url, T Function(Object? json)? fromJsonT, {dynamic data});
  Future<BaseResponseDto<T>> put<T>(String url, T Function(Object? json)? fromJsonT, {dynamic data});
  Future<BaseResponseDto<T>> delete<T>(String url, T Function(Object? json)? fromJsonT, {dynamic data});
}