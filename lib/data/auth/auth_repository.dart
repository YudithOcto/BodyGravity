import 'package:bodygravity/common/constants.dart';
import 'package:bodygravity/data/local/storage_service.dart';
import 'package:bodygravity/data/auth/model/auth/login_response_dto.dart';
import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/data/auth/model/base_response_dto.dart';
import 'package:bodygravity/data/network/network_services.dart';

abstract class AuthRepository {
  Future<BaseResponseDto> sendOtp(String email);
  Future<BaseResponseDto<LoginResponseDto>> login(String email, String otp);
  Future<BaseResponseDto<ProfileResponseDto>> getProfile();
  Future<BaseResponseDto> updateProfile(String? email, String? name);
  Future<void> saveBearerToken(String token);
  Future<String?> getBearerToken();
}

class DefaultAuthRepository extends AuthRepository {
  final NetworkService _networkService;
  final StorageService _localService;

  DefaultAuthRepository(this._networkService, this._localService);

  @override
  Future<BaseResponseDto<ProfileResponseDto>> getProfile() async {
    return await _networkService.get("/api/profile", (json) => ProfileResponseDto.fromJson(json as Map<String, dynamic>));
  }

  @override
  Future<BaseResponseDto<LoginResponseDto>> login(String email, String otp) async {
    return await _networkService.post("/api/login", (json) => LoginResponseDto.fromJson(json as Map<String, dynamic>), data: {
      "email": email,
      "otp": otp,
    });
  }

  @override
  Future<BaseResponseDto> sendOtp(String email) async {
    return await _networkService
        .post("/api/send-otp", null, data: {"email": email});
  }

  @override
  Future<BaseResponseDto> updateProfile(String? email, String? name) async {
    return await _networkService.put("/api/profile", null, data: {
      "email": email,
      "name": name,
    });
  }

  @override
  Future<String?> getBearerToken() async {
    return await _localService.getData(Constants.bearerToken);
  }

  @override
  Future<void> saveBearerToken(String token) async {
    return await _localService.saveData(Constants.bearerToken, token);
  }
}
