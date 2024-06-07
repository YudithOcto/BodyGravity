import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/ui/customer_detail_screen.dart';
import 'package:flutter/material.dart';
import '../common/customtextstyle.dart';

class ClientItemWidget extends StatelessWidget {
  final int index;

  const ClientItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.blueGray200),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.blueGray300,
              shape: BoxShape.circle,
            ),
            width: 40.0,
            height: 40.0,
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Klien $index", style: CustomTextStyle.headline5),
              const SizedBox(height: 4.0),
              Text("aaa@gmail.com", style: CustomTextStyle.caption2)
            ],
          ),
        ],
      ),
    );
  }
}
