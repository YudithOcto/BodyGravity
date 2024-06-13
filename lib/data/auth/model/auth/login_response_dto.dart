class LoginResponseDto {
  String? token;

  LoginResponseDto({this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        token: json["token"] ?? "",
      );
}
