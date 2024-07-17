import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.currency(locale: 'id', decimalDigits: 0);

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class CurrencyFormat {
  static String formatToRupiah(num? value) {
    if (value == null || value == 0.0) {
      return 'Rp 0';
    }

    final formatter = NumberFormat('#,###');
    return "Rp ${formatter.format(value)}";
  }
}
