// ignore_for_file: unnecessary_string_interpolations

import 'package:intl/intl.dart';

formatDecimal(String amount){
NumberFormat.currency(name: 'Rupiah: ').format('$amount');
}

