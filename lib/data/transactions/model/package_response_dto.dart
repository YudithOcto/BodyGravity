class PackageResponseDto {
  final String id;
  final String name;
  final num price;
  final int session;
  final int expiredInMonth;
  final bool isRoleAdmin;

  PackageResponseDto({
    required this.id,
    required this.name,
    required this.price,
    required this.session,
    required this.expiredInMonth,
    this.isRoleAdmin = false
  });

  factory PackageResponseDto.fromJson(Map<String, dynamic> json) {
    return PackageResponseDto(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      price: json["price"] ?? 0.0,
      session: json["session"] ?? 0,
      expiredInMonth: json["expired_in_month"] ?? 0,
    );
  }
}
