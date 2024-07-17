import 'dart:math';

import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/common/debouncer.dart';
import 'package:bodygravity/data/customer/model/customer_response_dto.dart';
import 'package:bodygravity/ui/client_item_widget.dart';
import 'package:bodygravity/ui/customer/bloc/customer_bloc.dart';
import 'package:bodygravity/ui/customer/bloc/customer_event.dart';
import 'package:bodygravity/ui/customer/bloc/customer_state.dart';
import 'package:bodygravity/ui/customer/customer_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionSearchWidget extends StatefulWidget {
  final Function(CustomerResponseDto) onItemSelected;

  const AddTransactionSearchWidget({super.key, required this.onItemSelected});

  @override
  createState() => _AddTransactionSearchWidgetState();
}

class _AddTransactionSearchWidgetState
    extends State<AddTransactionSearchWidget> {
  final _debouncer = Debouncer(milliseconds: 700);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CustomerBloc>(context).add(CustomerInitialLoadEvent());
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      BlocProvider.of<CustomerBloc>(context)
          .add(const LoadDataEvent(null, null));
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  focusNode: _focusNode,
                  style: CustomTextStyle.body3
                      .copyWith(color: AppColors.blackCustom),
                  cursorColor: AppColors.blackCustom,
                  onChanged: (newValue) {
                    _debouncer.run(() {
                      BlocProvider.of<CustomerBloc>(context)
                          .add(LoadDataEvent(newValue, 1));
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Cari Klien',
                      hintStyle: CustomTextStyle.body3
                          .copyWith(color: AppColors.blackCustom),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        borderSide: BorderSide(color: AppColors.blueGray50),
                      ),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: AppColors.blackCustom,
                      ),
                      contentPadding: const EdgeInsets.only(left: 12.0)),
                ),
              ),
            ),
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
                            child: AddClientWidget(
                              onAddClient: ((name, email, phone) {
                                BlocProvider.of<CustomerBloc>(context)
                                    .add(AddCustomerEvent(phone, email, name));
                              }),
                            ),
                          );
                        });
                  },
                  child: const Icon(
                    Icons.add_circle,
                    color: AppColors.green600,
                  )),
            ),
          ],
        ),
        BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            //no-op
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return state is LoadSuccessState && state.customers.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height *
                        (min(state.customers.length * 0.1, 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Scrollbar(
                      thickness: 6.0,
                      thumbVisibility: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.customers.length,
                        itemBuilder: (context, index) {
                          final customer = state.customers[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  _focusNode.unfocus();
                                  BlocProvider.of<CustomerBloc>(context)
                                      .add(CustomerInitialLoadEvent());
                                  widget.onItemSelected(customer);
                                },
                                child: ClientItemWidget(customer: customer)),
                          );
                        },
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
