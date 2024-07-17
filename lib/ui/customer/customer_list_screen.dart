import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:bodygravity/common/debouncer.dart';
import 'package:bodygravity/common/extension.dart';
import 'package:bodygravity/ui/customer/bloc/customer_bloc.dart';
import 'package:bodygravity/ui/customer/bloc/customer_event.dart';
import 'package:bodygravity/ui/customer/bloc/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/appcolors.dart';
import '../../common/customtextstyle.dart';
import '../client_item_widget.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _debouncer = Debouncer(milliseconds: 700);
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CustomerBloc>(context).add(const LoadDataEvent("", 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {},
        builder: (context, state) {
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
              title: Text("Seluruh Klien",
                  style: CustomTextStyle.headline4
                      .copyWith(color: AppColors.blueGray800)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            showDragHandle: true,
                            enableDrag: true,
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: AddClientWidget(
                                  onAddClient: ((name, email, phone) {
                                    BlocProvider.of<CustomerBloc>(context).add(
                                        AddCustomerEvent(phone, email, name));
                                  }),
                                ),
                              );
                            });
                      },
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Cari Klien",
                      onChanged: (newValue) {
                        _debouncer.run(() {
                          BlocProvider.of<CustomerBloc>(context)
                              .add(LoadDataEvent(newValue, 1));
                        });
                      },
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.blueGray300,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    state is LoadSuccessState
                        ? ListView.separated(
                            itemCount: state.customers.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 8.0);
                            },
                            itemBuilder: (context, index) {
                              final customer = state.customers[index];
                              return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(customer);
                                  },
                                  child: ClientItemWidget(customer: customer));
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.yellow500),
                              strokeWidth: 3.0,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class AddClientWidget extends StatefulWidget {
  final Function(String name, String email, String phone) onAddClient;
  final String? name;
  final String? email;
  final String? phone;
  const AddClientWidget(
      {super.key,
      required this.onAddClient,
      this.name,
      this.email,
      this.phone});

  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.maxFinite,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tambah Klien baru",
                style: CustomTextStyle.body2
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            CustomTextFieldTitle(
                title: "Nama ",
                textFieldWidget: CustomTextField(
                  textEditingController: _nameController,
                  validator: (value) =>
                      value.isNotNullOrEmpty ? null : "Harap isi nama",
                )),
            const SizedBox(height: 8.0),
            CustomTextFieldTitle(
                title: "Email ",
                textFieldWidget: CustomTextField(
                  textEditingController: _emailController,
                  validator: (value) => value.isNotNullOrEmpty &&
                          _isValidEmail(_emailController.text)
                      ? null
                      : "Email tidak valid",
                )),
            const SizedBox(height: 8.0),
            CustomTextFieldTitle(
                title: "Nomor Handphone ",
                textFieldWidget: CustomTextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value.isNotNullOrEmpty &&
                          _isValidNumber(_phoneController.text)
                      ? null
                      : "Nomor HP tidak valid",
                  textEditingController: _phoneController,
                )),
            const SizedBox(height: 8.0),
            CustomFilledButton(
              buttonText: "Simpan",
              onPressed: () {
                if (_globalKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  widget.onAddClient(
                    _nameController.text,
                    _emailController.text,
                    _phoneController.text,
                  );
                }
              },
              color: AppColors.green600,
            )
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  bool _isValidNumber(String phone) {
    final phoneRegex = RegExp(r'^(?:\+62\d{11,12}|08\d{10,11})$');
    return phoneRegex.hasMatch(phone);
  }
}
