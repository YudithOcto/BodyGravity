import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/customer_list_screen.dart';
import 'package:flutter/material.dart';

class SelectClientWidget extends StatelessWidget {
  const SelectClientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pilih Klien",
            style: CustomTextStyle.headline5,
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerListScreen()));
            },
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: AppColors.blueGray300,
                  borderRadius: BorderRadius.circular(8.0)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.perm_identity_outlined, size: 20.0),
                  const SizedBox(width: 12.0),
                  Text("Klien 1",
                      style: CustomTextStyle.body2
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}