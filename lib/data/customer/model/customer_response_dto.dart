class CustomerResponseDto {
  final String userId;
  final String name;
  final String email;
  final CustomerDetailResponseDto detail;

  CustomerResponseDto(
      {required this.userId,
      required this.name,
      required this.email,
      required this.detail});

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(
        userId: json['id'] ?? "",
        name: json['name'] ?? "",
        email: json["email"] ?? "",
        detail: json["customer"] == null
            ? CustomerDetailResponseDto(id: "", phone: "")
            : CustomerDetailResponseDto.fromJson(json["customer"]));
  }
}

class CustomerDetailResponseDto {
  final String id;
  final String phone;

  CustomerDetailResponseDto({required this.id, required this.phone});

  factory CustomerDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerDetailResponseDto(
        id: json["id"] ?? "", phone: json["phone"] ?? "");
  }
}