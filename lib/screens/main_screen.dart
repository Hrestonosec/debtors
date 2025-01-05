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
  final String _id = DateTime.now().toString();

  void _addDebtor(String name, double debt) {
    setState(() {
      _debtors.add(Debtor(id: _id, name: name, debt: debt));
    });
  }

  void _updateDebt(String id, double newDebt) {
    setState(() {
      final debtor = _debtors.firstWhere((debtor) => debtor.id == id);
      debtor.debt += newDebt;
    });
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
              onViewDetails: (debtor) {},
              onUpdateDebt: _updateDebt,
            ),
          ),
        ],
      ),
    );
  }
}
