import 'package:bodygravity/data/auth/model/base_response_dto.dart';
import 'package:bodygravity/data/network/network_services.dart';
import 'package:bodygravity/data/transactions/model/create_order_response_dto.dart';
import 'package:bodygravity/data/transactions/model/create_workout_response_dto.dart';
import 'package:bodygravity/data/transactions/model/dashboard_performance_dto.dart';
import 'package:bodygravity/data/transactions/model/package_response_dto.dart';
import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:bodygravity/data/transactions/model/update_workout_response_dto.dart';
import 'package:bodygravity/data/transactions/model/workout_response_dto.dart';

abstract class TransactionsRepository {
  Future<BaseResponseDto<List<PackageResponseDto>>> getTransactionPackage();
  Future<BaseResponseDto<CreateOrderResponseDto>> createOrder(
      String userId, String packageId);
  Future<BaseResponseDto<CreateWorkoutResponseDto>> createWorkout(
      String userId, String concern, String scheduleAt);
  Future<BaseResponseDto<UpdateWorkoutResponseDto>> updateWorkout(
      String id, String otp);
  Future<BaseResponseDto> sendWorkoutFinishedOtp(String id);
  Future<BaseResponseDto> getOrderList();
  Future<BaseResponseDto<List<TransactionResponseDto>>> getTransactions(
      String? queryCustomerName,
      String? startDate,
      String? endDate,
      int? page,
      int? pageSize);
  Future<BaseResponseDto<DashboardPerformanceDto>> getDashboardPerformance();
  Future<BaseResponseDto<List<WorkoutResponseDto>>> getWorkoutList();
  Future<BaseResponseDto> cancelWorkout(String workoutId);
}

class DefaultTransactionRepository extends TransactionsRepository {
  final NetworkService _networkService;
  DefaultTransactionRepository(this._networkService);
  @override
  Future<BaseResponseDto<List<PackageResponseDto>>>
      getTransactionPackage() async {
    return _networkService.get(
        "/api/package",
        (json) => (json as List<dynamic>)
            .map((e) => PackageResponseDto.fromJson(e))
            .toList());
  }

  @override
  Future<BaseResponseDto<CreateOrderResponseDto>> createOrder(
      String userId, String packageId) async {
    return _networkService.post("/api/order",
        (json) => CreateOrderResponseDto.fromJson(json as Map<String, dynamic>),
        data: {
          "user_id": userId,
          "package_id": packageId,
        });
  }

  @override
  Future<BaseResponseDto> getOrderList() async {
    return _networkService.get("/api/order", (json) => null);
  }

  @override
  Future<BaseResponseDto<List<TransactionResponseDto>>> getTransactions(
      String? queryCustomerName,
      String? startDate,
      String? endDate,
      int? page,
      int? pageSize) async {
    return _networkService.get(
        "/api/workout/latest",
        (json) => (json as List<dynamic>)
            .map((e) => TransactionResponseDto.fromJson(e))
            .toList(),
        queryParameters: {
          "search": queryCustomerName,
          "start_date": startDate,
          "end_date": endDate,
          "page": page,
          "page_size": pageSize,
        });
  }

  @override
  Future<BaseResponseDto<DashboardPerformanceDto>>
      getDashboardPerformance() async {
    return _networkService.get(
        "/api/workout/dashboard",
        (json) =>
            DashboardPerformanceDto.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<BaseResponseDto<CreateWorkoutResponseDto>> createWorkout(
      String userId, String concern, String scheduleAt) async {
    return _networkService.post(
        '/api/workout',
        (json) =>
            CreateWorkoutResponseDto.fromJson(json as Map<String, dynamic>),
        data: {
          "user_id": userId,
          "concern": concern,
          "scheduled_at": scheduleAt,
        });
  }

  @override
  Future<BaseResponseDto<UpdateWorkoutResponseDto>> updateWorkout(
      String id, String otp) async {
    return _networkService.put(
        '/api/workout/$id',
        (json) =>
            UpdateWorkoutResponseDto.fromJson(json as Map<String, dynamic>),
        data: {
          "status": "finished",
          "otp": otp,
        });
  }

  @override
  Future<BaseResponseDto<List<WorkoutResponseDto>>> getWorkoutList() async {
    return _networkService.get(
        "/api/workout",
        (json) => (json as List<dynamic>)
            .map((e) => WorkoutResponseDto.fromJson(e))
            .toList());
  }

  @override
  Future<BaseResponseDto> sendWorkoutFinishedOtp(String id) async {
    return _networkService.post("/api/workout/$id/send-otp", null);
  }

  @override
  Future<BaseResponseDto> cancelWorkout(String id) async {
    return _networkService.put('/api/workout/$id', (json) => null, data: {
      "status": "canceled",
    });
  }
}
