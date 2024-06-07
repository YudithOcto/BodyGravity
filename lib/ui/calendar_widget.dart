import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class CalendarWidget extends StatefulWidget {
  final List<dynamic> Function(DateTime)? events;
  const CalendarWidget({super.key, this.events});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        CustomTextStyle.headline5.copyWith(color: AppColors.blueGray900);
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 30)),
      lastDay: DateTime.now().add(const Duration(days: 90)),
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
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
