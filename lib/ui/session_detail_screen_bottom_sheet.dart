import 'package:flutter/material.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';

class SessionDetailScreenBottomSheet extends StatefulWidget {
  const SessionDetailScreenBottomSheet({super.key});

  @override
  State<SessionDetailScreenBottomSheet> createState() => _SessionDetailScreenBottomSheetState();
}

class _SessionDetailScreenBottomSheetState extends State<SessionDetailScreenBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_2_rounded),
                const SizedBox(width: 16.0),
                Text("Sesi Klien A", style: CustomTextStyle.headline3),
                const Spacer(),
                const Icon(Icons.close)
              ],
            ),
            const SizedBox(height: 24.0),
            const _SessionItemWidget(title: "Nama Workout", value: "Abs Workout"),
            const _detailDivider(),
            const _SessionItemWidget(title: "Tanggal dan Jam", value: "24 Maret 2024, 07:00 - 09:00 PM"),
            const _detailDivider(),
            const _SessionItemWidget(title: "Nomor Handphone", value: "08124019201"),
            const _detailDivider(),
            const _SessionItemWidget(title: "Pendapatan Sendiri", value: "Rp 120,000"),
            const _detailDivider(),
            const _SessionItemWidget(title: "Pendapatan Trainer Tambahan", value: "Rp 250,000"),
            const _detailDivider(),
            const _SessionItemWidget(title: "Total Pembayaran", value: "Rp 370,000"),
          ],
        ),
      ),
    );
  }
}

class _detailDivider extends StatelessWidget {
  const _detailDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: const Divider(
        thickness: 1,
        color: AppColors.blueGray300,
      ),
    );
  }
}


class _SessionItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const _SessionItemWidget(
      {required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: Text(title,
              style: CustomTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16.0),
        Flexible(
          flex: 6,
          child: Text(
            value,
            style:
                CustomTextStyle.body2.copyWith(color: AppColors.blueGray600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
