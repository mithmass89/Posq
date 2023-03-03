import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
   var x =   currencyFormatter.format(number);

     return 'Rp $x';
  
  }
}

class CurrencyFormatNo {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
   var x =   currencyFormatter.format(number);

     return '$x';
  
  }
}