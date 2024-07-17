import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../common/appcolors.dart';
import '../common/custom_filled_button.dart';
import '../common/customtextstyle.dart';
import 'calendar_widget.dart';

final today = DateUtils.dateOnly(DateTime.now());

class FilterScreen extends StatelessWidget {
  final Function(DateTime, DateTime) onFilterDate;
  const FilterScreen({super.key, required this.onFilterDate});

  static const routeName = '/filter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter Range Tanggal",
          style: CustomTextStyle.body3,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarWidget(
                firstDay: DateTime.now().subtract(const Duration(days: 150)),
                lastDay: DateTime.now(),
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                onRangeSelectedDate: (start, end) {
                  onFilterDate(start, end);
                },
              ),
              const SizedBox(height: 8.0),
              CustomFilledButton(
                height: 57.0,
                radius: 8.0,
                buttonText: "Terapkan",
                color: AppColors.green600,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterCardItemWidget extends StatelessWidget {
  final bool isEnabled;
  final String assetName;
  final String title;
  final VoidCallback onClick;

  const FilterCardItemWidget({
    super.key,
    required this.isEnabled,
    required this.assetName,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isEnabled ? AppColors.primary50 : AppColors.white900,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(assetName),
              color: AppColors.primary900,
              width: 32.0,
              height: 32.0,
            ),
            const SizedBox(width: 18.0),
            Text(
              title,
              style: CustomTextStyle.headline4
                  .copyWith(color: AppColors.blueGray900),
            ),
            const Spacer(),
            Image(
              image: AssetImage(
                  "assets/images/${isEnabled ? "ic_radio_active" : "ic_radio_inactive"}.png"),
              width: 24.0,
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
