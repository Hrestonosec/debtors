class TransactionsHistory {
  final String debtorId;
  final List<MapEntry<DateTime, double>> transactionsList;

  TransactionsHistory(this.debtorId,
      [List<MapEntry<DateTime, double>>? transactions])
      : transactionsList = transactions ?? [];

  void addTransaction(DateTime date, double amount) {
    transactionsList.insert(0, MapEntry(date, amount));
    if (transactionsList.length > 10) {
      transactionsList.removeLast();
    }
  }

  List<MapEntry<DateTime, double>> getSortedTransactions() {
    return List.from(transactionsList);
  }

  @override
  String toString() =>
      "Транзакції: ${transactionsList.map((entry) => "${entry.key}: ${entry.value.toStringAsFixed(2)}").join(", ")}";
}
