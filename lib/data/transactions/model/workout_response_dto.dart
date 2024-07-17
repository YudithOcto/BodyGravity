class WorkoutResponseDto {
  final String id;
  final String concern;
  final String scheduledAt;
  final String status;

  WorkoutResponseDto(
      {required this.id,
      required this.concern,
      required this.scheduledAt,
      required this.status});

  factory WorkoutResponseDto.fromJson(Map<String, dynamic> json) {
    return WorkoutResponseDto(
      id: json['id'] ?? '',
      concern: json['concern'] ?? '',
      scheduledAt: json['scheduled_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
