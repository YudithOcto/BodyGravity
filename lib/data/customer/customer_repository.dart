import 'package:bodygravity/data/auth/model/base_response_dto.dart';
import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:bodygravity/data/network/network_services.dart';

abstract class CustomerRepository {
  Future<BaseResponseDto<List<CustomerResponseDto>>> getCustomerList(
      String? query, int page);
  Future<BaseResponseDto> addCustomer(String email, String phone, String name);
}

class DefaultCustomerRepository extends CustomerRepository {
  final NetworkService _networkService;

  DefaultCustomerRepository(this._networkService);

  @override
  Future<BaseResponseDto<List<CustomerResponseDto>>> getCustomerList(
      String? query, int page) async {
    return await _networkService.get(
        "/api/customer",
        (json) => (json as List<dynamic>)
            .map((e) => CustomerResponseDto.fromJson(e))
            .toList(),
        queryParameters: {
          "page": page,
          "q": query,
        });
  }

  @override
  Future<BaseResponseDto> addCustomer(
      String email, String phone, String name) async {
    return await _networkService.post("/api/customer", (json) => null, data: {
      "email": email,
      "name": name,
      "phone": phone,
    });
  }
}
