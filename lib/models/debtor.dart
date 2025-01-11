import 'package:flutter/material.dart';

class Debtor {
  final String id;
  final String name;
  double debt = 0;
  Color debtColor;

  Debtor(
      {required this.id,
      required this.name,
      required this.debt,
      this.debtColor = Colors.red}) {
    if (name.isEmpty) {
      throw ArgumentError("Ім'я не може бути порожнім.");
    }
  }

  @override
  String toString() => "Боржник: $name, Борг: \$${debt.toStringAsFixed(2)}";
}
