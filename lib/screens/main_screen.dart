import 'package:debtors/models/transactions_history.dart';
import 'package:flutter/material.dart';
import 'package:debtors/models/debtor.dart';
import 'package:debtors/widgets/search_bar_widget.dart';
import 'package:debtors/widgets/add_debtor_widget.dart';
import 'package:debtors/widgets/debtor_list_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Debtor> _debtors = [];
  final Map<String, TransactionsHistory> _transactionHistories = {};

  void _addDebtor(String name, double debt) {
    setState(() {
      final String id = DateTime.now().toString();
      _debtors.add(Debtor(id: id, name: name, debt: debt));
      _transactionHistories[id] = TransactionsHistory(id);
      _transactionHistories[id]?.addTransaction(DateTime.now(), debt);
    });
  }

  void _updateDebt(String id, double newDebt) {
    setState(() {
      final debtor = _debtors.firstWhere((debtor) => debtor.id == id);
      debtor.debt += newDebt;
      _transactionHistories[id]?.addTransaction(DateTime.now(), newDebt);
    });
  }

  void _viewDetails(Debtor debtor) {
    final history =
        _transactionHistories[debtor.id]?.getSortedTransactions() ?? [];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Історія транзакцій для ${debtor.name}"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text("${entry.key.toLocal()}"),
                  subtitle: Text("Сума: ${entry.value.toStringAsFixed(2)}"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Закрити"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AddDebtorWidget(
            onAddDebtor: _addDebtor,
          ),
          Expanded(
            child: DebtorListWidget(
              debtors: _debtors,
              onViewDetails: _viewDetails,
              onUpdateDebt: _updateDebt,
            ),
          ),
        ],
      ),
    );
  }
}
