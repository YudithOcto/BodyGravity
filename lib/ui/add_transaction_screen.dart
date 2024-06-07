import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/ui/select_client_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  int activeIndex = 0;
  final TextEditingController _controller = TextEditingController();

  String _formatCurrency(String text) {
    if (text.isEmpty) {
      return '';
    }

    final number = int.parse(text);
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      _controller.value = _controller.value.copyWith(
        text: _formatCurrency(text),
        selection:
            TextSelection.collapsed(offset: _formatCurrency(text).length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary900,
        automaticallyImplyLeading: true,
        elevation: 0.0,
        title: Text("Tambah Transaksi",
            style: CustomTextStyle.headline4
                .copyWith(color: AppColors.blueGray800)),
      ),
      bottomNavigationBar: CustomFilledButton(
        height: 64.0,
        color: AppColors.primary900,
        buttonText: 'Tambah Transaksi',
        radius: 0.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const SelectClientWidget(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 24.0,
              ),
              child: Text("Pilih Paket", style: CustomTextStyle.headline4),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: activeIndex == index
                              ? AppColors.yellow500
                              : Colors.transparent,
                          border: Border.all(
                            color: activeIndex == index
                                ? Colors.transparent
                                : AppColors.blueGray200,
                          )),
                      child: Row(
                        children: [
                          Icon(
                            Icons.run_circle,
                            color: activeIndex == index
                                ? AppColors.white900
                                : AppColors.blueGray300,
                            size: 42.0,
                          ),
                          const SizedBox(width: 12.0),
                          Visibility(
                            visible: index != 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(index == 0 ? "Paket A" : "Paket B",
                                    style: CustomTextStyle.body3
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4.0),
                                Text(index == 0 ? "50 Sesi" : "100 Sesi",
                                    style: CustomTextStyle.caption1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blueGray400)),
                                const SizedBox(height: 4.0),
                                Text(
                                  index == 0
                                      ? "Rp 50,000,000"
                                      : "Rp 100,000,000",
                                  style: CustomTextStyle.body3.copyWith(
                                      color: AppColors.blackCustom,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: index == 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Paket Khusus",
                                    style: CustomTextStyle.body3
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 3,
              ),
            ),
            Visibility(
              visible: activeIndex == 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: CustomTextFieldTitle(
                          title: "Jumlah Sesi",
                          textFieldWidget: CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      flex: 7,
                      child: CustomTextFieldTitle(
                          title: "Harga Paket",
                          textFieldWidget: CustomTextField(
                            // textEditingController: _controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomTextFieldTitle(
                  title: "Catatan",
                  textFieldWidget: CustomTextField(
                    maxLines: 8,
                    contentPadding: EdgeInsets.all(16.0),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
