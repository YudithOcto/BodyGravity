import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/currency_formatter.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/data/transactions/model/dashboard_performance_dto.dart';
import 'package:bodygravity/data/transactions/model/transaction_response_dto.dart';
import 'package:bodygravity/data/transactions/model/workout_response_dto.dart';
import 'package:bodygravity/ui/chart/chart_screen.dart';
import 'package:bodygravity/ui/transactions/add_session/add_session_screen.dart';
import 'package:bodygravity/ui/transactions/add_transactions/add_transaction_screen.dart';
import 'package:bodygravity/ui/customer_session_item_widget.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_event.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_state.dart';
import 'package:bodygravity/ui/filter_screen.dart';
import 'package:bodygravity/ui/profile_screen.dart';
import 'package:bodygravity/ui/transactions/end_session/end_session_screen.dart';
import 'package:bodygravity/ui/transactions/search/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isShowFilterActive = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DashboardBloc>(context).add(LoadDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
        buildWhen: (previous, current) {
      if (previous is LoadedState && current is LoadedState) {
        return (previous.latestTransactions.length !=
                current.latestTransactions.length) ||
            previous.isShowChart != current.isShowChart;
      } else if (previous is DashboardLoadingState && current is LoadedState ||
          previous is DashboardLoadingState && current is ErrorState) {
        return true;
      } else if (current is DashboardLoadingState) {
        return true;
      } else if (current is OpeningChartState) {
        return false;
      }
      return false;
    }, listener: (context, state) {
      if (state is LoadedState && state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFF3ADC84),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: const Color(0xFF3ADC84),
          backgroundColor: const Color(0xFF3ADC84),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Datang,",
                  style: CustomTextStyle.body3
                      .copyWith(color: AppColors.blueGray500)),
              const SizedBox(height: 4.0),
              if (state is LoadedState) ...[
                Text("${(state).profileData.name} 👋🏻",
                    style: CustomTextStyle.caption1
                        .copyWith(fontWeight: FontWeight.bold)
                        .copyWith(color: AppColors.blueGray800)),
              ]
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                if (state is LoadedState) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(profileData: state.profileData)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const ProfileScreen(profileData: null)));
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 16.0),
                child: const Image(
                  image: AssetImage("assets/images/ic_default_profile.png"),
                  width: 42.0,
                  height: 42.0,
                ),
              ),
            ),
          ],
        ),
        body: state is DashboardLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.yellow500),
                  strokeWidth: 3.0,
                ),
              )
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<DashboardBloc>(context)
                          .add(LoadDataEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 72.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state is LoadedState
                                ? _MonthlyPerformanceWidget(state.dashboardData)
                                : const SizedBox(),
                            state is LoadedState
                                ? _QuickActionWidget(
                                    profile: state.profileData,
                                    nextSessions: state.nextSessions,
                                    onRefresh: () {
                                      BlocProvider.of<DashboardBloc>(context)
                                          .add(LoadDataEvent());
                                    })
                                : const SizedBox(),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionListScreen()));
                              },
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 2.0,
                                  margin: const EdgeInsets.all(16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.search, size: 18.0),
                                        const SizedBox(width: 8.0),
                                        Text("Cari Transaksi",
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color:
                                                        AppColors.blackCustom,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Sesi Terselesaikan",
                                    style: CustomTextStyle.headline4,
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      if (state is LoadedState) {
                                        BlocProvider.of<DashboardBloc>(context)
                                            .add(UpdateTransactionViewTypeEvent(
                                                !state.isShowChart));
                                      }
                                      //   showModalBottomSheet(
                                      //       context: context,
                                      //       isScrollControlled: false,
                                      //       isDismissible: true,
                                      //       showDragHandle: true,
                                      //       enableDrag: true,
                                      //       backgroundColor: Colors.white,
                                      //       builder: (context) {
                                      // return SfCartesianChart(
                                      //     borderColor:
                                      //         Colors.transparent,
                                      //     primaryXAxis:
                                      //         const CategoryAxis(
                                      //       majorGridLines:
                                      //           MajorGridLines(
                                      //               width: 0),
                                      //       axisLine:
                                      //           AxisLine(width: 0),
                                      //     ),
                                      //     primaryYAxis: NumericAxis(
                                      //       anchorRangeToVisiblePoints:
                                      //           true,
                                      //       numberFormat:
                                      //           NumberFormat.compact(),
                                      //     ),
                                      //     // Chart title
                                      //     // Enable legend
                                      //     legend: const Legend(
                                      //         isVisible: true),
                                      //     // Enable tooltip
                                      //     tooltipBehavior:
                                      //         TooltipBehavior(
                                      //             enable: true),
                                      //     series: <ColumnSeries<
                                      //         ChartData, String>>[
                                      //       ColumnSeries<ChartData,
                                      //               String>(
                                      //           dataSource: state
                                      //               .latestTransactions
                                      //               .map((e) => ChartData(
                                      //                   DateTimeUtil.convertToIndonesianDate(
                                      //                       e.date),
                                      //                   e.fee))
                                      //               .toList(),
                                      //           xValueMapper:
                                      //               (ChartData sales, _) =>
                                      //                   sales.date,
                                      //           yValueMapper:
                                      //               (ChartData sales, _) =>
                                      //                   sales.fee,
                                      //           name: 'Pendapatan',
                                      //           borderRadius:
                                      //               BorderRadius.circular(
                                      //                   8.0),
                                      //           // Enable data label
                                      //           dataLabelSettings:
                                      //               const DataLabelSettings(
                                      //                   isVisible:
                                      //                       false)),
                                      //     ]);
                                      //       });
                                      // }
                                    },
                                    child: state is LoadedState &&
                                            state.isShowChart
                                        ? const Icon(Icons.view_list_rounded)
                                        : const Icon(
                                            Icons.bar_chart_outlined,
                                            color: AppColors.blackCustom,
                                          ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FilterScreen(
                                                    onFilterDate: (start, end) {
                                                      BlocProvider.of<
                                                                  DashboardBloc>(
                                                              context)
                                                          .add(UpdateDateFilter(
                                                              start, end));
                                                    },
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.filter_list_sharp,
                                      color: AppColors.blackCustom,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            state is LoadedState &&
                                    state.latestTransactions.isNotEmpty
                                ? state.isShowChart
                                    ? SfCartesianChart(
                                        borderColor: Colors.transparent,
                                        primaryXAxis: CategoryAxis(
                                          borderColor: Colors.white,
                                          labelStyle: CustomTextStyle.caption1
                                              .copyWith(color: Colors.black),
                                          majorGridLines:
                                              const MajorGridLines(width: 0),
                                          axisLine: const AxisLine(width: 0),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          borderColor: Colors.white,
                                          anchorRangeToVisiblePoints: true,
                                          numberFormat: NumberFormat.compact(),
                                        ),
                                        legend: const Legend(isVisible: true),
                                        tooltipBehavior:
                                            TooltipBehavior(enable: true),
                                        series: <ColumnSeries<ChartData,
                                            String>>[
                                            ColumnSeries<ChartData, String>(
                                                color: AppColors.yellow500,
                                                dataSource: state
                                                    .latestTransactions
                                                    .map((e) => ChartData(
                                                        DateTimeUtil
                                                            .convertToIndonesianDate(
                                                                e.date),
                                                        e.fee))
                                                    .toList(),
                                                xValueMapper:
                                                    (ChartData sales, _) =>
                                                        sales.date,
                                                yValueMapper:
                                                    (ChartData sales, _) =>
                                                        sales.fee,
                                                name: 'Pendapatan',
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                // Enable data label
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        isVisible: false)),
                                          ])
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(
                                          height: 16.0,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.latestTransactions.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              state.latestTransactions[index];
                                          return InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  showDragHandle: true,
                                                  backgroundColor: Colors.white,
                                                  enableDrag: true,
                                                  builder: (context) {
                                                    return TransactionDetailBottomSheetWidget(
                                                        date: item.date,
                                                        sessions:
                                                            item.sessions);
                                                  });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              decoration: BoxDecoration(
                                                  color: AppColors.white900,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0)),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                AppColors
                                                                    .blackCustom,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: const Icon(
                                                      Icons.shopping_bag,
                                                      size: 16.0,
                                                      color: AppColors.white900,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${item.sessions.length} Sesi',
                                                        style: CustomTextStyle
                                                            .body3
                                                            .copyWith(
                                                                color: AppColors
                                                                    .blackCustom),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Text(
                                                        DateTimeUtil
                                                            .convertToIndonesianDate(
                                                                item.date),
                                                        style: CustomTextStyle
                                                            .caption2
                                                            .copyWith(
                                                                color: AppColors
                                                                    .blackCustom),
                                                      )
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    CurrencyFormat
                                                        .formatToRupiah(
                                                            item.fee),
                                                    style: CustomTextStyle.body3
                                                        .copyWith(
                                                            color: AppColors
                                                                .blackCustom),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                : Container(
                                    margin: const EdgeInsets.all(36.0),
                                    child: Text(
                                      "Transaksi tidak di temukan. Silahkan coba di tanggal lain",
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyle.body3,
                                    ),
                                  ),
                            Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.hourglass_empty,
                                        color: AppColors.blueGray400),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      "Tidak ada transaksi terbaru",
                                      style: CustomTextStyle.caption1.copyWith(
                                          color: AppColors.blueGray400),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  state is LoadedState && state.isUpdating
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.yellow500),
                            strokeWidth: 3.0,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
      );
    });
  }
}

class _QuickActionWidget extends StatefulWidget {
  final ProfileResponseDto profile;
  final VoidCallback onRefresh;
  final List<WorkoutResponseDto> nextSessions;
  const _QuickActionWidget(
      {required this.profile,
      required this.onRefresh,
      required this.nextSessions});

  @override
  State<_QuickActionWidget> createState() => _QuickActionWidgetState();
}

class _QuickActionWidgetState extends State<_QuickActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Menu Aksi", style: CustomTextStyle.headline4),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                splashColor: AppColors.blackCustom,
                onTap: () async {
                  final isNeedToRefresh =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddTransactionScreen(
                                currentUserRole: widget.profile.role,
                              )));
                  if (isNeedToRefresh) {
                    widget.onRefresh();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.yellow500,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: Colors.black,
                        size: 28.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Buat\nTransaksi",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.caption1
                            .copyWith(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              InkWell(
                splashColor: AppColors.blackCustom,
                onTap: () async {
                  final isNeedToRefresh = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AddSessionScreen()));
                  if (isNeedToRefresh) {
                    widget.onRefresh();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.green600,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Jadwalkan\nSesi",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.caption1
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              InkWell(
                splashColor: AppColors.blackCustom,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      showDragHandle: true,
                      enableDrag: true,
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: NextSessionWidget(
                            sessions: widget.nextSessions,
                            onCancelSession: (workoutId) async {
                              final result = await showModalBottomSheet(
                                  context: context,
                                  enableDrag: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Apakah kamu yakin mau membatalkan sesi ini?",
                                              style: CustomTextStyle.body3),
                                          const SizedBox(height: 12.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: CustomFilledButton(
                                                    color: AppColors.green600,
                                                    buttonText: "Iya",
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    }),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Adjust the radius as needed
                                                    ),
                                                    side: const BorderSide(
                                                        color: Colors.green,
                                                        width:
                                                            2.0), // Set the border color and width
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "batalkan",
                                                    style: CustomTextStyle.body3
                                                        .copyWith(
                                                            color: AppColors
                                                                .blackCustom),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                              if (result && mounted) {
                                Navigator.of(context).pop();
                                BlocProvider.of<DashboardBloc>(context)
                                    .add(CancelWorkoutEvent(workoutId));
                              }
                            },
                            onEndSession: (sessionId) {
                              BlocProvider.of<DashboardBloc>(context)
                                  .add(LoadDataEvent());
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.red500,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 28.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Ada Sesi\nTerjadwal",
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.caption1
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyPerformanceWidget extends StatefulWidget {
  final DashboardPerformanceDto? data;
  const _MonthlyPerformanceWidget(this.data);

  @override
  State<_MonthlyPerformanceWidget> createState() =>
      _MonthlyPerformanceWidgetState();
}

class _MonthlyPerformanceWidgetState extends State<_MonthlyPerformanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Performa", style: CustomTextStyle.headline4),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChartScreen()));
                  },
                  child: Text("Lihat Semua", style: CustomTextStyle.body3)),
            ],
          ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: true,
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.primary900),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReportWidget(
                        icon: Icons.money,
                        title: "Bulan Ini",
                        value: CurrencyFormat.formatToRupiah(
                            widget.data?.currentMonth?.fee),
                        totalSession: widget.data?.currentMonth?.session ?? 0,
                      ),
                      Container(
                        color: AppColors.blueGray400,
                        height: 40.0,
                        width: 1.0,
                      ),
                      ReportWidget(
                        icon: Icons.money,
                        title: "Bulan Lalu",
                        value: CurrencyFormat.formatToRupiah(
                            widget.data?.lastMonth?.fee),
                        totalSession: widget.data?.lastMonth?.session ?? 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  const Icon(Icons.hourglass_empty,
                      color: AppColors.blueGray400),
                  const SizedBox(height: 8.0),
                  Text(
                    "Tidak ada history Performa di bulan sebelum ini atau bulan ini",
                    style: CustomTextStyle.caption1
                        .copyWith(color: AppColors.blueGray400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NextSessionWidget extends StatelessWidget {
  final List<WorkoutResponseDto> sessions;
  final Function(String) onEndSession;
  final Function(String) onCancelSession;
  const NextSessionWidget(
      {super.key,
      required this.sessions,
      required this.onEndSession,
      required this.onCancelSession});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Sesi Terjadwal", style: CustomTextStyle.headline4),
          const SizedBox(height: 8.0),
          sessions.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = sessions[index];
                    return CustomerSessionItemWidget(
                      width: double.maxFinite,
                      workout: item,
                      onCancel: (workoutId) {
                        onCancelSession(workoutId);
                      },
                      onSessionStart: () {
                        showModalBottomSheet(
                            context: context,
                            enableDrag: true,
                            isDismissible: true,
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return EndSessionScreen(
                                  workoutId: item.id,
                                  onRefresh: () {
                                    onEndSession(item.id);
                                    Navigator.of(context).pop();
                                  });
                            });
                      },
                      needToShowSplit: false,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12.0),
                  itemCount: sessions.length)
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                      "Tidak ada sesi terjadwal. Silahkan buat sesi terlebih dahulu."))
        ],
      ),
    );
  }
}

class ReportWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final int totalSession;

  const ReportWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.totalSession,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyle.caption1
                .copyWith(fontWeight: FontWeight.bold, color: AppColors.red500),
          ),
          const SizedBox(height: 4.0),
          Text(value,
              style: CustomTextStyle.body3.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4.0),
          Text("$totalSession Sesi",
              style: CustomTextStyle.caption2.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class TransactionDetailBottomSheetWidget extends StatelessWidget {
  final List<TransactionSessionDto> sessions;
  final String date;
  const TransactionDetailBottomSheetWidget(
      {super.key, required this.date, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaksi ${DateTimeUtil.convertToIndonesianDate(date)}",
            style: CustomTextStyle.headline5,
          ),
          const SizedBox(height: 16.0),
          ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemCount: sessions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = sessions[index];
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.blueGray300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: AppColors.green600,
                    ),
                    const SizedBox(width: 12.0),
                    Text(item.customerName,
                        style: CustomTextStyle.body3.copyWith(
                            color: AppColors.blackCustom,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pendapatan",
                          style: CustomTextStyle.caption1
                              .copyWith(color: AppColors.blackCustom),
                        ),
                        Text(
                          CurrencyFormat.formatToRupiah(item.trainerFee),
                          style: CustomTextStyle.body3.copyWith(
                              color: AppColors.blackCustom,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
