import 'package:bodygravity/common/constants.dart';
import 'package:bodygravity/common/extension.dart';
import 'package:bodygravity/data/local/storage_service.dart';
import 'package:bodygravity/data/auth/model/base_response_dto.dart';
import 'package:bodygravity/data/network/network_services.dart';
import 'package:bodygravity/main.dart';
import 'package:bodygravity/ui/auth/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioService implements NetworkService {
  final Dio _dio;
  final StorageService storageService;

  DioService(this._dio, this.storageService) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await storageService.getData(Constants.bearerToken);
        debugPrint(token);
        if (token.isNotNullOrEmpty) {
          options.headers["Accept"] = "application/json";
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          _redirectToLogin();
        }
        return handler.next(error);
      },
    ));
  }

  void _redirectToLogin() {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  @override
  Future<BaseResponseDto<T>> get<T>(
      String url, T Function(Object? json)? fromJsonT,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return BaseResponseDto.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponseDto(isSuccess: false, message: getErrorMessages(e));
    }
  }

  @override
  Future<BaseResponseDto<T>> post<T>(
      String url, T Function(Object? json)? fromJsonT,
      {data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return BaseResponseDto.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponseDto(isSuccess: false, message: getErrorMessages(e));
    }
  }

  @override
  Future<BaseResponseDto<T>> put<T>(
      String url, T Function(Object? json)? fromJsonT,
      {data}) async {
    try {
      final response = await _dio.put(url, data: data);
      return BaseResponseDto.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponseDto(isSuccess: false, message: getErrorMessages(e));
    }
  }

  @override
  Future<BaseResponseDto<T>> delete<T>(
      String url, T Function(Object? json)? fromJsonT,
      {data}) async {
    try {
      final response = await _dio.delete(url);
      return BaseResponseDto.fromJson(response.data, fromJsonT);
    } catch (e) {
      return BaseResponseDto(isSuccess: false, message: getErrorMessages(e));
    }
  }

  String convertResponseErrorMessage(Map<String, dynamic> body) {
    String message = body['message'];
    return message;
  }

  String getErrorMessages(Object exception) {
    if (exception is DioException) {
      return handleError(exception);
    } else {
      return exception.toString();
    }
  }

  String handleError(DioException error) {
    final errorMessage = error.response?.data["message"];
    return errorMessage ??
        error.message ??
        "Telah Terjadi Kesalahan. Silahkan Coba Lagi";
  }
}
