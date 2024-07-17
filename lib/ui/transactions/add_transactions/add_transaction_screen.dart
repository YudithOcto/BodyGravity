import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/currency_formatter.dart';
import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/data/auth/model/auth/profile_response_dto.dart';
import 'package:bodygravity/ui/transactions/add_transactions/add_transaction_search_widget.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_bloc.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_event.dart';
import 'package:bodygravity/ui/transactions/bloc/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final Role currentUserRole;
  const AddTransactionScreen({super.key, required this.currentUserRole});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TransactionBloc>(context)
        .add(LoadPackagetEvent(widget.currentUserRole));
    _controller.addListener(() {
      final text = _controller.text;
      _controller.value = _controller.value.copyWith(
        text: CurrencyFormat.formatToRupiah(double.parse(text)),
        selection: TextSelection.collapsed(
            offset: CurrencyFormat.formatToRupiah(double.parse(text)).length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
        buildWhen: (previous, current) {
      if (previous is LoadedAddTransactionState &&
          current is LoadedAddTransactionState) {
        return previous.user != current.user ||
            previous.selectedPackage != current.selectedPackage;
      }

      if ((previous is InitialTransactionState ||
              previous is TransactionLoadingState) &&
          (current is LoadedAddTransactionState ||
              current is FailedPackageState)) {
        return true;
      }

      return false;
    }, listener: (context, state) {
      if (state is FailedAddTransactionState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is AddTransactionSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
      }
    }, builder: (context, state) {
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
            color: AppColors.green600,
            buttonText: 'Tambah Transaksi',
            isEnabled: state is LoadedAddTransactionState &&
                state.selectedPackage != null &&
                state.user != null,
            radius: 0.0,
            onPressed: () {
              if (state is LoadedAddTransactionState) {
                if (state.selectedPackage != null && state.user != null) {
                  BlocProvider.of<TransactionBloc>(context).add(
                      AddTransactionEvent(
                          state.user!.userId, state.selectedPackage!.id));
                }
              }
            },
          ),
          body: state is LoadedAddTransactionState
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      // SelectClientWidget(
                      //     selectedUser: state.user,
                      //     onSelectedCustomer: (user) {
                      //       BlocProvider.of<TransactionBloc>(context)
                      //           .add(SelectedClientEvent(user));
                      //     }),
                      AddTransactionSearchWidget(
                        onItemSelected: (user) {
                          BlocProvider.of<TransactionBloc>(context)
                              .add(SelectedClientEvent(user));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 24.0,
                        ),
                        child: Text("Pilih Paket",
                            style: CustomTextStyle.headline4),
                      ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final package = state.packages[index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                BlocProvider.of<TransactionBloc>(context)
                                    .add(SelectedPackageEvent(package, index));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: state.activeIndex == index
                                        ? AppColors.yellow500
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: state.activeIndex == index
                                          ? Colors.transparent
                                          : AppColors.blueGray200,
                                    )),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.run_circle,
                                      color: state.activeIndex == index
                                          ? AppColors.white900
                                          : AppColors.blueGray300,
                                      size: 42.0,
                                    ),
                                    const SizedBox(width: 12.0),
                                    Visibility(
                                      visible: !package.isRoleAdmin,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              (widget.currentUserRole ==
                                                          Role.admin &&
                                                      index ==
                                                          state.packages
                                                                  .length -
                                                              1)
                                                  ? "Paket Khusus"
                                                  : package.name,
                                              style: CustomTextStyle.body3
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(height: 4.0),
                                          Text(
                                              "${package.session.toString()} Sesi",
                                              style: CustomTextStyle.caption1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .blueGray400)),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 2)
                                                .format(package.price),
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color:
                                                        AppColors.blackCustom,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: package.isRoleAdmin,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Paket Khusus",
                                              style: CustomTextStyle.body3
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(height: 4.0),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: state.packages.length,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Visibility(
                        visible: widget.currentUserRole == Role.admin &&
                            (state.activeIndex ?? 0) ==
                                state.packages.length - 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16.0, top: 16.0),
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
                      Visibility(
                        visible: state.user != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 16.0,
                                  bottom: 8.0),
                              child: Text("Klien yang dipilih",
                                  style: CustomTextStyle.headline4),
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: AppColors.blueGray300,
                                  borderRadius: BorderRadius.circular(8.0)),
                              margin: const EdgeInsets.only(
                                  right: 16.0, left: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.perm_identity_outlined,
                                      size: 20.0),
                                  const SizedBox(width: 12.0),
                                  Text(
                                      state.user?.name ??
                                          "Harap Pilih Klien dahulu",
                                      style: CustomTextStyle.body2.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: state.user != null
                                              ? Colors.black
                                              : Colors.black38)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : state is TransactionLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : Container());
    });
  }
}
