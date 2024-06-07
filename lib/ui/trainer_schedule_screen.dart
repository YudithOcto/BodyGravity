import 'dart:math';

import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/ui/add_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';
import 'customer_session_item_widget.dart';

class TrainerScheduleScreen extends StatefulWidget {
  const TrainerScheduleScreen({super.key});

  @override
  State<TrainerScheduleScreen> createState() => _TrainerScheduleScreenState();
}

class _TrainerScheduleScreenState extends State<TrainerScheduleScreen> {
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
    for (int i = 0; i < 6; i++) {
      final currDate = currentDate.add(Duration(days: i));
      nextFourDays.add(currDate);
    }
    return nextFourDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white900,
        automaticallyImplyLeading: true,
        elevation: 0.0,
        title: Text("Jadwal Training",
            style: CustomTextStyle.headline4
                .copyWith(color: AppColors.blueGray800)),
      ),
      bottomNavigationBar: CustomFilledButton(
        height: 64.0,
        color: AppColors.primary900,
        buttonText: 'Tambah Jadwal',
        radius: 0.0,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddSessionScreen()));
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: _getNextFourDays(_currentDate).map((date) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                                color: _selectedDate.day == date.day
                                    ? AppColors.primary900
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                    color: _selectedDate.day == date.day
                                        ? AppColors.primary900
                                        : AppColors.blueGray100)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
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
                  ],
                ),
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
                
                    needToShowSplit: index == 0,
                    isTransferred: index == 1,
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
