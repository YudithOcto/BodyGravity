import 'package:bodygravity/common/common_divider.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:bodygravity/ui/customer/customer_list_screen.dart';
import 'package:bodygravity/ui/select_client_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../common/appcolors.dart';
import '../common/custom_filled_button.dart';
import '../common/customtextstyle.dart';
import 'calendar_widget.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white900,
        automaticallyImplyLeading: true,
        elevation: 0.0,
        title: Text("Tambah Jadwal Latihan",
            style: CustomTextStyle.headline4
                .copyWith(color: AppColors.blueGray800)),
      ),
      bottomNavigationBar: CustomFilledButton(
        height: 64.0,
        color: AppColors.green600,
        buttonText: 'Tambah',
        radius: 0.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectClientWidget(),
            CommonDivider(),
            _AssistedTrainerWidget(),
            CommonDivider(),
            _SelectDateTimeWidget(),
          ],
        ),
      ),
    );
  }
}

class _AssistedTrainerWidget extends StatefulWidget {
  const _AssistedTrainerWidget();

  @override
  State<_AssistedTrainerWidget> createState() => _AssistedTrainerWidgetState();
}

class _AssistedTrainerWidgetState extends State<_AssistedTrainerWidget> {
  bool _needsAssistedTrainer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do you need an assisted trainer?',
            style: CustomTextStyle.headline5,
          ),
          Checkbox(
            value: _needsAssistedTrainer,
            onChanged: (value) {
              setState(() {
                _needsAssistedTrainer = value!;
              });
            },
          ),
          if (_needsAssistedTrainer) ...[
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {},
              child: CustomTextFieldTitle(
                  title: "Cari Nama Trainer",
                  textFieldWidget: const CustomTextField(
                    hintText: "Masukkan nama trainer",
                    isEnabled: false,
                  ),
                  style: CustomTextStyle.headline4),
            ),
            const SizedBox(height: 8.0),
            CustomTextFieldTitle(
                title: "Fee",
                textFieldWidget: CustomTextField(
                  hintText: "Masukkan Fee Trainer",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ))
          ],
        ],
      ),
    );
  }
}

class _SelectDateTimeWidget extends StatefulWidget {
  const _SelectDateTimeWidget();

  @override
  State<_SelectDateTimeWidget> createState() => _SelectDateTimeWidgetState();
}

class _SelectDateTimeWidgetState extends State<_SelectDateTimeWidget> {
  TimeOfDay? _selectedTimeFrom;

  final TextEditingController _fromController = TextEditingController();

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTimeFrom = picked;
        _fromController.text = DateFormat.jm()
            .format(DateTime(2022, 1, 1, picked.hour, picked.minute));
      });
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextFieldTitle(
              title: "Keluhan",
              textFieldWidget: CustomTextField(
                maxLines: 4,
              )),
          const SizedBox(height: 16.0),
          CustomTextFieldTitle(
              title: "Pilih Jam",
              textFieldWidget: InkWell(
                onTap: () {
                  _selectTime(context, true);
                },
                child: CustomTextField(
                  isEnabled: false,
                  hintText: "",
                  textEditingController: _fromController,
                ),
              ),
              style: CustomTextStyle.headline5),
          const SizedBox(height: 24.0),
          Text("Pilih Tanggal", style: CustomTextStyle.headline5),
          const SizedBox(height: 16.0),
          Container(
              decoration: BoxDecoration(
                  color: AppColors.white900,
                  borderRadius: BorderRadius.circular(16.0)),
              child: const CalendarWidget())
        ],
      ),
    );
  }
}
