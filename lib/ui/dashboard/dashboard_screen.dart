import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/add_session_screen.dart';
import 'package:bodygravity/ui/add_transaction_screen.dart';
import 'package:bodygravity/ui/customer_session_item_widget.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_event.dart';
import 'package:bodygravity/ui/dashboard/bloc/dashboard_state.dart';
import 'package:bodygravity/ui/filter_screen.dart';
import 'package:bodygravity/ui/profile_screen.dart';
import 'package:bodygravity/ui/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isShowFilterActive = false;
  final List<Map<String, dynamic>> data = [
    {'tanggal': '31 Maret 2024', 'sesi': '5', 'pendapatan': 'Rp5,000,000'},
    {'tanggal': '30 Maret 2024', 'sesi': '6', 'pendapatan': 'Rp3,000,000'},
    {'tanggal': '29 Maret 2024', 'sesi': '8', 'pendapatan': 'Rp2,000,000'},
    {'tanggal': '28 Maret 2024', 'sesi': '9', 'pendapatan': 'Rp1,500,000'},
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DashboardBloc>(context).add(LoadDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white900,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.white900,
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
            body: state is LoadingState
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.yellow500),
                      strokeWidth: 3.0,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 72.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _MonthlyPerformanceWidget(),
                          const _QuickActionWidget(),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Transaksi Terbaru",
                                    style: CustomTextStyle.headline4),
                                const Spacer(),
                                Visibility(
                                  visible: false,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TransactionListScreen()));
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      color: AppColors.blackCustom,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const FilterScreen()));
                                  },
                                  child: const Icon(
                                    Icons.filter_list_sharp,
                                    color: AppColors.blackCustom,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionListScreen()));
                              },
                              child: Card(
                                elevation: 3.0,
                                child: Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.white900,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Cari Transaksi Klien",
                                        style: CustomTextStyle.body3,
                                      ),
                                      const Icon(
                                        Icons.search,
                                        color: AppColors.green600,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const SizedBox(
                              height: 16.0,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
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
                                        return const TransactionDetailBottomSheetWidget();
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.blueGray200),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: const BoxDecoration(
                                            color: AppColors.blackCustom,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.shopping_bag,
                                          size: 16.0,
                                          color: AppColors.white900,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item['sesi']} Sesi',
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color:
                                                        AppColors.blackCustom),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            '${item['tanggal']}',
                                            style: CustomTextStyle.caption2
                                                .copyWith(
                                                    color:
                                                        AppColors.blackCustom),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${data[index]['pendapatan']}",
                                        style: CustomTextStyle.body3.copyWith(
                                            color: AppColors.blackCustom),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
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
                    ),
                  ),
          );
        });
  }
}

class _QuickActionWidget extends StatelessWidget {
  const _QuickActionWidget({super.key});

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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen()));
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddSessionScreen()));
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
                          child: const NextSessionWidget(),
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

class _MonthlyPerformanceWidget extends StatelessWidget {
  const _MonthlyPerformanceWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(48.0),
            bottomRight: Radius.circular(48.0),
          )),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Performa", style: CustomTextStyle.headline4),
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
                          value: "Rp3,000,000"),
                      Container(
                        color: AppColors.blueGray400,
                        height: 40.0,
                        width: 1.0,
                      ),
                      ReportWidget(
                          icon: Icons.money,
                          title: "Bulan Lalu",
                          value: "Rp2,000,000"),
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
  const NextSessionWidget({super.key});

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
          CustomerSessionItemWidget(
            width: double.maxFinite,
            day: "10",
            month: "May",
            onSessionStart: () {
              showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Masukkan OTP",
                              style: CustomTextStyle.headline3),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Kami mengirimkan otp ke ',
                              style: CustomTextStyle.body3
                                  .copyWith(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'EMAIL ',
                                    style: CustomTextStyle.body3.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.green600)),
                                TextSpan(
                                    text:
                                        " klien anda. Silahkan untuk meminta pada klien",
                                    style: CustomTextStyle.body3
                                        .copyWith(color: Colors.black))
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(top: 48.0, bottom: 32.0),
                            child: OTPTextField(
                              length: 4,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 40,
                              style: CustomTextStyle.body3,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                print("Completed: $pin");
                              },
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Tidak menerima OTP?',
                              style: CustomTextStyle.body3
                                  .copyWith(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Kirim Ulang',
                                    style: CustomTextStyle.body3.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary900)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          CustomFilledButton(
                            buttonText: "Lanjutkan",
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: AppColors.green600,
                          )
                        ],
                      ),
                    );
                  });
            },
            needToShowSplit: false,
          )
        ],
      ),
    );
  }
}

class ReportWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ReportWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

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
          Text("30 Sesi",
              style: CustomTextStyle.caption2.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class TransactionDetailBottomSheetWidget extends StatelessWidget {
  const TransactionDetailBottomSheetWidget({super.key});

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
            "Transaksi 31 Maret 2024",
            style: CustomTextStyle.headline5,
          ),
          const SizedBox(height: 16.0),
          ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
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
                    Text("John Doe",
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
                          "Rp 1.000.000",
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
