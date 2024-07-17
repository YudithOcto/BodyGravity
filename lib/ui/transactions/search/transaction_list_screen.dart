import 'package:bodygravity/common/appcolors.dart';
import 'package:bodygravity/common/currency_formatter.dart';
import 'package:bodygravity/common/customtextstyle.dart';
import 'package:bodygravity/common/datetime_util.dart';
import 'package:bodygravity/common/debouncer.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_bloc.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_event.dart';
import 'package:bodygravity/ui/transactions/search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final _debouncer = Debouncer(milliseconds: 700);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(LoadSearchEvent());
  }

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
        title: Text(
          "Transaksi",
          style: CustomTextStyle.body2,
        ),
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    style: CustomTextStyle.body3
                        .copyWith(color: AppColors.blackCustom),
                    cursorColor: AppColors.blackCustom,
                    onChanged: (newValue) {
                      _debouncer.run(() {
                        BlocProvider.of<SearchBloc>(context)
                            .add(LoadSearchEvent(query: newValue));
                      });
                    },
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Cari Transaksi Klien',
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
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      state is LoadedSearchState
                          ? state.transactions.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) => const SizedBox(
                                    height: 16.0,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.transactions.length,
                                  itemBuilder: (context, index) {
                                    final item = state.transactions[index];
                                    return Container(
                                      padding: const EdgeInsets.all(16.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.blueGray200),
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: const BoxDecoration(
                                                color: AppColors.blackCustom,
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                              Icons.shopping_bag,
                                              size: 16.0,
                                              color: AppColors.white900,
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.sessions.firstOrNull
                                                        ?.customerName ??
                                                    '',
                                                style: CustomTextStyle.body3
                                                    .copyWith(
                                                        color: AppColors
                                                            .blackCustom),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                DateTimeUtil
                                                    .convertToIndonesianDate(
                                                        item.date),
                                                style: CustomTextStyle.caption2
                                                    .copyWith(
                                                        color: AppColors
                                                            .blackCustom),
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            CurrencyFormat.formatToRupiah(item
                                                    .sessions
                                                    .firstOrNull
                                                    ?.trainerFee ??
                                                0.0),
                                            style: CustomTextStyle.body3
                                                .copyWith(
                                                    color:
                                                        AppColors.blackCustom),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Tidak ditemukan data klien. Silahkan cari nama client lainnya",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : state is LoadingSearchState
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Silahkan cari transaksi berdasarkan Nama Klien",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
