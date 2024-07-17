import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/chart/bloc/chart_bloc.dart';
import 'package:bodygravity/ui/chart/bloc/chart_event.dart';
import 'package:bodygravity/ui/chart/bloc/chart_state.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<Chartbloc>(context)
        .add(LoadChartEvent(DateTime.now().year));
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List<int>.generate(6, (index) => currentYear - index);
    return BlocConsumer<Chartbloc, ChartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Pendapatan Tahun ${state is ChartSuccessState ? state.currentYear : ""}",
                style: CustomTextStyle.body2,
              ),
            ),
            body: state is ChartLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state is ChartSuccessState
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DropdownButton<int>(
                              hint: Text(
                                "Pilih Tahun",
                                style: CustomTextStyle.body3,
                              ),
                              value: selectedYear,
                              items: years.map((int year) {
                                return DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedYear = newValue;
                                });
                                BlocProvider.of<Chartbloc>(context)
                                    .add(LoadChartEvent(newValue!));
                              },
                            ),
                            Expanded(
                              child: SfCartesianChart(
                                  borderColor: Colors.transparent,
                                  primaryXAxis: CategoryAxis(
                                    borderColor: Colors.white,
                                    labelStyle: CustomTextStyle.caption1
                                        .copyWith(color: Colors.black),
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                    axisLine: const AxisLine(width: 0),
                                    maximumLabels:
                                        6, // Adjust based on your needs
                                    labelIntersectAction:
                                        AxisLabelIntersectAction.rotate45,
                                  ),
                                  primaryYAxis: NumericAxis(
                                    borderColor: Colors.white,
                                    anchorRangeToVisiblePoints: true,
                                    numberFormat: NumberFormat.compact(),
                                  ),
                                  legend: const Legend(isVisible: true),
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <ColumnSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                        color: AppColors.yellow500,
                                        dataSource: state.data
                                            .map((e) => ChartData(e.monthName,
                                                e.totalAccumulatedFee))
                                            .toList(),
                                        xValueMapper: (ChartData sales, _) =>
                                            sales.date,
                                        yValueMapper: (ChartData sales, _) =>
                                            sales.fee,
                                        name: 'Pendapatan',
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // Enable data label
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: false)),
                                  ]),
                            ),
                          ],
                        ),
                      )
                    : Container(),
          );
        });
  }
}
