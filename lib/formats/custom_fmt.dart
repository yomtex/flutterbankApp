import 'package:intl/intl.dart';

String fmtCurrency(String amt, String symbol, int decimalCount) {
  var amt_conv = double.parse(amt);
  final fmtCurrency =
      new NumberFormat.currency(decimalDigits: decimalCount, symbol: symbol);
  return fmtCurrency.format(amt_conv);
}
