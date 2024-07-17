class CreateOrderResponseDto {
  final String customerId;
  final String packageId;
  final int totalSession;
  final num price;
  final String expiredDate;
  final int currentSession;
  final num pricePerSession;
  final String status;
  final String id;

  CreateOrderResponseDto(
      {required this.customerId,
      required this.packageId,
      required this.totalSession,
      required this.price,
      required this.expiredDate,
      required this.currentSession,
      required this.pricePerSession,
      required this.status,
      required this.id});

  factory CreateOrderResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponseDto(
      customerId: json['customer_id'] ?? '',
      packageId: json['package_id'] ?? '',
      totalSession: json['session_total'] ?? 0,
      price: json['price'] ?? 0.0,
      expiredDate: json['expired_date'] ?? '',
      currentSession: json['session_current'] ?? 0,
      pricePerSession: json['price_per_session'] ?? 0.0,
      status: json['status'] ?? "",
      id: json['id'] ?? "",
    );
  }
}
