import 'package:intl/intl.dart';

class PaymentAmountSuggestion {
  final List<int> _amounts = [50000, 100000, 200000, 500000, 1000000];
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  String getFormattedAmount(int amount) {
    return _currencyFormat.format(amount);
  }

  List<String> getSuggestions(int currentAmount) {
    List<String> suggestions = [];
    for (int amount in _amounts) {
      if (amount > currentAmount) {
        suggestions.add(getFormattedAmount(amount));
      }
    }
    return suggestions;
  }
}
