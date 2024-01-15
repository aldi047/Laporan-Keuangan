import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(String number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(int.parse(number));
  }
}
