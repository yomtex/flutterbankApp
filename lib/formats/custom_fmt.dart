import 'package:intl/intl.dart';

String fmtCurrency(num amt, String symbol, int decimalCount) {
  final fmtCurrency =
      new NumberFormat.currency(decimalDigits: decimalCount, symbol: symbol);
  return fmtCurrency.format(amt);
}
