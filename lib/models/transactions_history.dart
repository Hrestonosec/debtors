class TransactionsHistory {
  final int id;
  final Map<DateTime, double> transactionsList;

  TransactionsHistory(this.id, [Map<DateTime, double>? transactions])
      : transactionsList = transactions ?? {};

  void addTransaction(DateTime date, double amount) {
    transactionsList[date] = amount;
  }

  List<MapEntry<DateTime, double>> getSortedTransactions() {
    return transactionsList.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }

  @override
  String toString() =>
      "Транзакції: ${transactionsList.map((k, v) => MapEntry(k, v.toStringAsFixed(2)))}";
}
