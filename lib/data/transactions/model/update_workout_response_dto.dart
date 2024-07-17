class UpdateWorkoutResponseDto {
  final String id;
  final String orderId;
  final String concern;
  final String scheduleAt;
  final String status;
  final num price;
  final num trainerFee;

  UpdateWorkoutResponseDto(
      {required this.id,
      required this.orderId,
      required this.concern,
      required this.scheduleAt,
      required this.status,
      required this.price,
      required this.trainerFee});

  factory UpdateWorkoutResponseDto.fromJson(Map<String, dynamic> json) {
    return UpdateWorkoutResponseDto(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      concern: json['concern'] ?? '',
      scheduleAt: json['scheduled_at'] ?? '',
      status: json['status'] ?? '',
      price: json['price'] ?? 0.0,
      trainerFee: json['trainer_fee'] ?? 0.0,
    );
  }
}