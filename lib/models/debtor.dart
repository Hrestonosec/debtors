class Debtor {
  final String id;
  final String name;
  double debt = 0;

  Debtor({required this.id, required this.name, required this.debt}) {
    if (name.isEmpty) {
      throw ArgumentError("Ім'я не може бути порожнім.");
    }
  }

  @override
  String toString() => "Боржник: $name, Борг: \$${debt.toStringAsFixed(2)}";
}
