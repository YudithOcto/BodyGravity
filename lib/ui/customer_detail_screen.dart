import 'dart:math';

import 'package:bodygravity/ui/customer_session_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String title;

  const CustomerDetailScreen({super.key, required this.title});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late DateTime _currentDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = DateTime.now();
  }

  List<DateTime> _getNextFourDays(DateTime currentDate) {
    final List<DateTime> nextFourDays = [];
    for (int i = 0; i < 4; i++) {
      final currDate = currentDate.add(Duration(days: i));
      nextFourDays.add(currDate);
    }
    return nextFourDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white900,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white900,
        automaticallyImplyLeading: true,
        elevation: 0.0,
        title: Text("Profil Klien",
            style: CustomTextStyle.headline4
                .copyWith(color: AppColors.blueGray800)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.blueGray400, width: 3.0)),
                padding: const EdgeInsets.all(4.0),
                child: const Image(
                  image: AssetImage("assets/images/ic_default_profile.png"),
                  width: 60.0,
                  height: 60.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.title,
                style: CustomTextStyle.headline4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                "Tanggal Bergabung: 12-10-2023",
                style: CustomTextStyle.caption1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.green600,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("26",
                                style: CustomTextStyle.body1
                                    .copyWith(color: Colors.white)),
                            Text("Sesi Tersisa",
                                style: CustomTextStyle.caption1
                                    .copyWith(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.red600,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("15-10-2024",
                                style: CustomTextStyle.body1
                                    .copyWith(color: Colors.white)),
                            Text("Membership Expired",
                                style: CustomTextStyle.caption1
                                    .copyWith(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sesi Terjadwal", style: CustomTextStyle.headline3),
                  Text("Tambah",
                      style: CustomTextStyle.body3.copyWith(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          _currentDate =
                              _currentDate.subtract(const Duration(days: 4));
                        });
                      },
                      child: Text(
                        "<<<",
                        style: CustomTextStyle.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueGray400),
                      )),
                  Row(
                    children: _getNextFourDays(_currentDate).map((date) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedDate.day == date.day
                                ? AppColors.primary900
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('EEE').format(date),
                                style: CustomTextStyle.body3.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedDate.day == date.day
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              Text(
                                DateFormat('dd').format(date),
                                style: CustomTextStyle.body2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedDate.day == date.day
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _currentDate =
                              _currentDate.add(const Duration(days: 4));
                        });
                      },
                      child: Text(
                        ">>>",
                        style: CustomTextStyle.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      )),
                ],
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                itemCount: Random().nextInt(10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomerSessionItemWidget(
                    width: double.maxFinite,
                    day: DateFormat('dd').format(_selectedDate),
                    month: DateFormat('MMM').format(_selectedDate),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
