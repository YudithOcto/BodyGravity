import 'package:bodygravity/common/common_divider.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_bloc.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_event.dart';
import 'package:bodygravity/ui/transactions/add_session/bloc/add_session_state.dart';
import 'package:bodygravity/ui/transactions/add_transactions/add_transaction_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/appcolors.dart';
import '../../../common/custom_filled_button.dart';
import '../../../common/customtextstyle.dart';
import '../../calendar_widget.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  @override
  void initState() {
    BlocProvider.of<AddSessionBloc>(context).add(InitAddSessionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSessionBloc, AddSessionState>(
        listener: (context, state) {
      if (state is SubmitFailedState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is SubmitSuccessState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
        Navigator.of(context).pop(true);
      }
    }, builder: (context, state) {
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
          isEnabled: state is AddSessionFormDataState &&
              state.selectedCustomer != null &&
              state.selectedDate != null &&
              state.selectedTime != null,
          buttonText: 'Tambah',
          radius: 0.0,
          onPressed: () {
            BlocProvider.of<AddSessionBloc>(context).add(SubmitDataEvent());
          },
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SelectClientWidget(
                  //   selectedUser: state is AddSessionFormDataState
                  //       ? state.selectedCustomer
                  //       : null,
                  //   onSelectedCustomer: (user) {
                  //     BlocProvider.of<AddSessionBloc>(context)
                  //         .add(UpdateCustomerEvent(user));
                  //   },
                  // ),
                  // CommonDivider(),
                  // _AssistedTrainerWidget(),
                  AddTransactionSearchWidget(
                    onItemSelected: (user) {
                      BlocProvider.of<AddSessionBloc>(context)
                          .add(UpdateCustomerEvent(user));
                    },
                  ),
                  const CommonDivider(),
                  (state is AddSessionFormDataState) &&
                          state.selectedCustomer != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 8.0),
                              child: Text("Klien yang dipilih",
                                  style: CustomTextStyle.headline4),
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: AppColors.blueGray300,
                                  borderRadius: BorderRadius.circular(8.0)),
                              margin: const EdgeInsets.only(
                                  right: 16.0, left: 16.0, bottom: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.perm_identity_outlined,
                                      size: 20.0),
                                  const SizedBox(width: 12.0),
                                  Text(
                                      state.selectedCustomer?.name ??
                                          "Harap Pilih Klien dahulu",
                                      style: CustomTextStyle.body2.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: state.selectedCustomer != null
                                              ? Colors.black
                                              : Colors.black38)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  _SelectDateTimeWidget(
                    onDateSelected: (date) {
                      BlocProvider.of<AddSessionBloc>(context)
                          .add(UpdateDateEvent(date));
                    },
                    onTimeSelected: (time) {
                      BlocProvider.of<AddSessionBloc>(context)
                          .add(UpdateTimeEvent(time));
                    },
                    concernFilledIn: (value) {
                      BlocProvider.of<AddSessionBloc>(context)
                          .add(UpdateConcernEvent(value));
                    },
                  ),
                ],
              ),
            ),
            if (state is AddSessionLoadingState) ...[
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.red500,
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    });
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
  final Function(TimeOfDay) onTimeSelected;
  final Function(DateTime) onDateSelected;
  final Function(String) concernFilledIn;
  const _SelectDateTimeWidget(
      {required this.onTimeSelected,
      required this.onDateSelected,
      required this.concernFilledIn});

  @override
  State<_SelectDateTimeWidget> createState() => _SelectDateTimeWidgetState();
}

class _SelectDateTimeWidgetState extends State<_SelectDateTimeWidget> {
  final TextEditingController _fromController = TextEditingController();

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      widget.onTimeSelected(picked);
      setState(() {
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
          CustomTextFieldTitle(
              title: "Keluhan",
              textFieldWidget: CustomTextField(
                contentPadding: const EdgeInsets.all(12.0),
                onChanged: (newValue) {
                  widget.concernFilledIn(newValue);
                },
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
              child: CalendarWidget(
                rangeSelectionMode: RangeSelectionMode.disabled,
                onSingleSelectedDate: (selectedDate) {
                  widget.onDateSelected(selectedDate);
                },
              ))
        ],
      ),
    );
  }
}
