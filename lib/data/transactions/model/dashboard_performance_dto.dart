class DashboardPerformanceDto {
  final DashboardPerformanceDetailDto? currentMonth;
  final DashboardPerformanceDetailDto? lastMonth;

  DashboardPerformanceDto({this.currentMonth, this.lastMonth});

  factory DashboardPerformanceDto.fromJson(Map<String, dynamic> json) {
    return DashboardPerformanceDto(
      currentMonth: json["current_month"] !=  null ? DashboardPerformanceDetailDto.fromJson(json['current_month']): null, 
      lastMonth: json['last_month'] != null ? DashboardPerformanceDetailDto.fromJson(json['last_month']): null
    );
  }
}

class DashboardPerformanceDetailDto {
  final int session;
  final num fee;

  DashboardPerformanceDetailDto({required this.fee,required this.session});

  factory DashboardPerformanceDetailDto.fromJson(Map<String, dynamic> json) {
    return DashboardPerformanceDetailDto(fee: json["fee"] ?? 0.0, session: json["sessions"] ?? 0);
  }
}