import 'package:bodygravity/ui/session_detail_screen_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class CustomerSessionItemWidget extends StatelessWidget {
  final VoidCallback? onSessionStart;
  final VoidCallback? onReschedule;
  final double? width;
  final String day;
  final String month;
  final bool needToShowSplit;
  final bool isTransferred;

  const CustomerSessionItemWidget(
      {super.key,
      this.onReschedule,
      this.onSessionStart,
      this.width,
      required this.day,
      required this.month,
      this.needToShowSplit = true,
      this.isTransferred = false});

  @override
  Widget build(BuildContext context) {
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
                              Text(day,
                                  style: CustomTextStyle.body2
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Text(month, style: CustomTextStyle.caption1),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 8.0),
                          RowSessionItemDetail(
                            icon: Icons.star_rounded,
                            title: "Keluhan: Pinggang Sakit",
                            isNeedBlue: true,
                          ),
                          SizedBox(height: 8.0),
                          RowSessionItemDetail(
                              icon: Icons.timer, title: "07:30 - 09:00 PM"),
                          SizedBox(height: 8.0),
                          RowSessionItemDetail(
                              icon: Icons.wifi_protected_setup_sharp,
                              title: "Status: Selesai")
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: onReschedule != null || onSessionStart != null,
                  child: const Divider(
                    thickness: 1,
                    color: AppColors.blueGray100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                  child: InkWell(
                    onTap: () {
                      if (onSessionStart != null) {
                        onSessionStart!();
                      }
                    },
                    child: Text(
                      "Mulai Sesi",
                      style: CustomTextStyle.body3.copyWith(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.bold),
                    ),
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
          color: isNeedBlue ? AppColors.primary900 : Colors.black,
        ),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: CustomTextStyle.body3.copyWith(
              color: isNeedBlue ? AppColors.primary900 : Colors.black),
        )
      ],
    );
  }
}
