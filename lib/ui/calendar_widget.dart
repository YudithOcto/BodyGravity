import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

typedef StartDate = DateTime;
typedef EndDate = DateTime;

class CalendarWidget extends StatefulWidget {
  final List<dynamic> Function(DateTime)? events;
  final Function(DateTime)? onSingleSelectedDate;
  final Function(StartDate, EndDate)? onRangeSelectedDate;
  final RangeSelectionMode rangeSelectionMode;
  final DateTime? firstDay;
  final DateTime? lastDay;
  const CalendarWidget({
    super.key,
    this.events,
    required this.rangeSelectionMode,
    this.onSingleSelectedDate,
    this.onRangeSelectedDate,
    this.firstDay,
    this.lastDay,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late RangeSelectionMode _rangeSelectionMode;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late DateTime firstDay;
  late DateTime lastDay;

  @override
  void initState() {
    super.initState();
    _rangeSelectionMode = widget.rangeSelectionMode;
    firstDay = widget.firstDay ?? DateTime.now().subtract(const Duration(days: 30));
    lastDay = widget.lastDay ?? DateTime.now().add(const Duration(days: 90));
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        CustomTextStyle.headline5.copyWith(color: AppColors.blueGray900);
    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarStyle: CalendarStyle(
        rangeHighlightColor: AppColors.primary50,
        rangeEndDecoration: const BoxDecoration(
            color: AppColors.green600, shape: BoxShape.circle),
        rangeStartDecoration: const BoxDecoration(
            color: AppColors.green600, shape: BoxShape.circle),
        rangeEndTextStyle: defaultTextStyle.copyWith(color: AppColors.white900),
        todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white900,
            border: Border.all(width: 1.0, color: AppColors.green600)),
        withinRangeTextStyle: defaultTextStyle,
        rangeStartTextStyle:
            defaultTextStyle.copyWith(color: AppColors.white900),
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle,
        outsideTextStyle:
            CustomTextStyle.headline5.copyWith(color: AppColors.blueGray300),
        defaultTextStyle: defaultTextStyle,
        todayTextStyle: defaultTextStyle,
      ),
      eventLoader: widget.events,
      headerStyle: HeaderStyle(
          leftChevronMargin: const EdgeInsets.only(left: 30.0),
          rightChevronMargin: const EdgeInsets.only(right: 30.0),
          formatButtonVisible: false,
          rightChevronVisible: true,
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            size: 30,
            color: AppColors.green600,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            size: 30.0,
            color: AppColors.green600,
          ),
          headerMargin: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: AppColors.blueGray50,
              borderRadius: BorderRadius.circular(12.0)),
          titleCentered: true,
          titleTextStyle:
              CustomTextStyle.headline4.copyWith(color: AppColors.blueGray900)),
      rangeSelectionMode: _rangeSelectionMode,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null; // Important to clean those
            _rangeEnd = null;
            _rangeSelectionMode = RangeSelectionMode.toggledOff;
            if (widget.onSingleSelectedDate != null) {
              widget.onSingleSelectedDate!(selectedDay);
            }
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
          if (widget.onRangeSelectedDate != null &&
              start != null &&
              end != null) {
            widget.onRangeSelectedDate!(start, end);
          }
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
