class AutoPaymentSuggestion {
  List<int> roundAmount(int amount) {
    var thresholds = {12000: 15000, 22000: 25000, 30000: 30000, 50000: 50000, 95000: 95000};
    var roundedAmounts = <int>[];
    thresholds.forEach((key, value) {
      if (amount >= key) {
        roundedAmounts.add(value);
      }
    });
    if (roundedAmounts.isEmpty) {
      roundedAmounts.add(amount);
    }
    return roundedAmounts;
  }
  
  String getPaymentSuggestion(int amount) {
    var roundedAmounts = roundAmount(amount);
    var suggestionText = 'You can pay ';
    for (var i = 0; i < roundedAmounts.length; i++) {
      if (i > 0) {
        suggestionText += ', ';
      }
      suggestionText += '${roundedAmounts[i]}';
    }
    if (roundedAmounts.length > 1) {
      suggestionText += ' (rounded from $amount)';
    }
    suggestionText += '.';
    return suggestionText;
  }
}
