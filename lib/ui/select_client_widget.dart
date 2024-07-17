import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:bodygravity/ui/customer/customer_list_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectClientWidget extends StatelessWidget {
  Function(CustomerResponseDto user) onSelectedCustomer;
  CustomerResponseDto? selectedUser;
  SelectClientWidget(
      {super.key, this.selectedUser, required this.onSelectedCustomer});

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
            onTap: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerListScreen()));
              if (result is CustomerResponseDto) {
                onSelectedCustomer(result);
              }
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
                  Text(selectedUser?.name ?? "Harap Pilih Klien dahulu",
                      style: CustomTextStyle.body2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selectedUser != null
                              ? Colors.black
                              : Colors.black38)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
