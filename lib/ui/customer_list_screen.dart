import 'package:bodygravity/common/custom_filled_button.dart';
import 'package:bodygravity/common/custom_text_field.dart';
import 'package:bodygravity/common/custom_text_field_title.dart';
import 'package:flutter/material.dart';

import '../common/appcolors.dart';
import '../common/customtextstyle.dart';
import 'client_item_widget.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
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
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const AddClientWidget(),
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
              const CustomTextField(
                hintText: "Cari Klien",
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.blueGray300,
                ),
              ),
              const SizedBox(height: 12.0),
              ListView.separated(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: ClientItemWidget(index: index + 1));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddClientWidget extends StatefulWidget {
  const AddClientWidget({super.key});

  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CustomTextFieldTitle(
              title: "Nama ",
              textFieldWidget: CustomTextField(
                textEditingController: _nameController,
              )),
          const SizedBox(height: 8.0),
          CustomTextFieldTitle(
              title: "Email ",
              textFieldWidget: CustomTextField(
                textEditingController: _ageController,
              )),
          const SizedBox(height: 8.0),
          CustomTextFieldTitle(
              title: "Nomor Handphone ",
              textFieldWidget: CustomTextField(
                textEditingController: _ageController,
              )),
          const SizedBox(height: 8.0),
          CustomFilledButton(
            buttonText: "Simpan",
            onPressed: () {},
            color: AppColors.green600,
          )
        ],
      ),
    );
  }
}
