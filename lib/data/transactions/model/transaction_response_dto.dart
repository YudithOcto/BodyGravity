class TransactionResponseDto {
  final String date;
  final List<TransactionSessionDto> sessions;
  final num fee;

  TransactionResponseDto(
      {required this.date, required this.sessions, required this.fee});

  factory TransactionResponseDto.fromJson(Map<String, dynamic> json) {
    return TransactionResponseDto(
        date: json['date'] ?? '',
        sessions: json['sessions'] != null
            ? (json['sessions'] as List<dynamic>)
                .map((e) => TransactionSessionDto.fromJson(e))
                .toList()
            : [],
        fee: json['total_fee'] ?? 0.0);
  }
}

class TransactionSessionDto {
  final String customerName;
  final num trainerFee;

  TransactionSessionDto({required this.customerName, required this.trainerFee});

  factory TransactionSessionDto.fromJson(Map<String, dynamic> json) {
    return TransactionSessionDto(
      customerName: json['name'] ?? '',
      trainerFee: json['fee'] ?? 0.0,
    );
  }
}
