class CreateWorkoutResponseDto {
  final String id;
  final String orderId;
  final String concern;
  final num price;
  final num trainerFee;

  CreateWorkoutResponseDto(
      {required this.id,
      required this.orderId,
      required this.concern,
      required this.price,
      required this.trainerFee});

  factory CreateWorkoutResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateWorkoutResponseDto(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      concern: json['concern'] ?? '',
      price: json['price'] ?? 0.0,
      trainerFee: json['trainer_fee'] ?? 0.0,
    );
  }
}
