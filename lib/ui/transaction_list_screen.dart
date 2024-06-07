import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final List<Map<String, dynamic>> data = [
    {'tanggal': '31 Maret 2024', 'sesi': '5', 'pendapatan': 'Rp5,000,000'},
    {'tanggal': '30 Maret 2024', 'sesi': '6', 'pendapatan': 'Rp3,000,000'},
    {'tanggal': '29 Maret 2024', 'sesi': '8', 'pendapatan': 'Rp2,000,000'},
    {'tanggal': '28 Maret 2024', 'sesi': '9', 'pendapatan': 'Rp1,500,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary900,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: TextFormField(
          style: CustomTextStyle.body3.copyWith(color: AppColors.white900),
          cursorColor: AppColors.white900,
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.blueGray700,
              hintText: 'Cari Transaksi Klien',
              hintStyle:
                  CustomTextStyle.body3.copyWith(color: AppColors.white900),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(
                Icons.search,
                color: AppColors.white900,
              ),
              contentPadding: EdgeInsets.only(left: 12.0)),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: ListView.separated(
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
                    enableDrag: true,
                    backgroundColor: AppColors.blackCustom,
                    builder: (context) {
                      return const TransactionDetailBottomSheetWidget();
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.blueGray200),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: AppColors.blackCustom, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.shopping_bag,
                        size: 16.0,
                        color: AppColors.white900,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['sesi']} Sesi',
                          style: CustomTextStyle.body3
                              .copyWith(color: AppColors.blackCustom),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${item['tanggal']}',
                          style: CustomTextStyle.caption2
                              .copyWith(color: AppColors.blackCustom),
                        )
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "${data[index]['pendapatan']}",
                      style: CustomTextStyle.body3
                          .copyWith(color: AppColors.blackCustom),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
