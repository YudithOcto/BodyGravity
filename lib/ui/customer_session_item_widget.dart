import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/data/transactions/model/workout_response_dto.dart';
import 'package:bodygravity/ui/session_detail_screen_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class CustomerSessionItemWidget extends StatelessWidget {
  final VoidCallback? onSessionStart;
  final Function(String)? onCancel;
  final double? width;
  final WorkoutResponseDto workout;
  final bool needToShowSplit;
  final bool isTransferred;

  const CustomerSessionItemWidget(
      {super.key,
      this.onCancel,
      this.onSessionStart,
      this.width,
      required this.workout,
      this.needToShowSplit = true,
      this.isTransferred = false});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(workout.scheduledAt);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true,
            backgroundColor: Colors.white,
            builder: (context) {
              return const SessionDetailScreenBottomSheet();
            });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            width: width,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.blueGray200),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(32.0),
                  bottomRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              color: AppColors.blueGray200,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0),
                              )),
                          child: Column(
                            children: [
                              Text(date.day.toString(),
                                  style: CustomTextStyle.body2
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Text(DateTimeUtil.getMonthName(date),
                                  style: CustomTextStyle.caption1),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 8.0),
                          RowSessionItemDetail(
                            icon: Icons.star_rounded,
                            title: "Keluhan: ${workout.concern}",
                            isNeedBlue: true,
                          ),
                          const SizedBox(height: 8.0),
                          RowSessionItemDetail(
                              icon: Icons.timer,
                              title:
                                  "Jam: ${DateTimeUtil.extractTimeWithoutSeconds(date)}"),
                          const SizedBox(height: 8.0),
                          RowSessionItemDetail(
                              icon: Icons.wifi_protected_setup_sharp,
                              title: "Status: ${workout.status}")
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: onCancel != null || onSessionStart != null,
                  child: const Divider(
                    thickness: 1,
                    color: AppColors.blueGray100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (onSessionStart != null) {
                            onSessionStart!();
                          }
                        },
                        child: Text(
                          "Selesaikan Sesi",
                          style: CustomTextStyle.body3.copyWith(
                              color: AppColors.green600,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {
                          if (onCancel != null) {
                            onCancel!(workout.id);
                          }
                        },
                        child: Text(
                          "Batalkan",
                          style: CustomTextStyle.body3.copyWith(
                              color: AppColors.red500,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0)
              ],
            ),
          ),
          Visibility(
            visible: needToShowSplit || isTransferred,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color:
                      isTransferred ? Colors.pinkAccent : AppColors.primary900,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  )),
              child: Text(
                isTransferred ? "Pindahan Sesi" : "Pendapatan Terpisah",
                style: CustomTextStyle.caption1.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RowSessionItemDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isNeedBlue;

  const RowSessionItemDetail(
      {super.key,
      required this.icon,
      required this.title,
      this.isNeedBlue = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.0,
          color: isNeedBlue ? AppColors.green600 : Colors.black,
        ),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: CustomTextStyle.body3
              .copyWith(color: isNeedBlue ? AppColors.green600 : Colors.black),
        )
      ],
    );
  }
}
