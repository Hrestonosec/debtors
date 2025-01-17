import 'package:flutter/material.dart';

import 'package:debtors/models/transactions_history.dart';
import 'package:debtors/models/debtor.dart';

import 'package:debtors/services/cloud_storage.dart';
import 'package:debtors/services/local_storage.dart';

import 'package:debtors/widgets/search_bar_widget.dart';
import 'package:debtors/widgets/add_debtor_widget.dart';
import 'package:debtors/widgets/debtor_list_widget.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Debtor> _debtors = [];
  final Map<String, TransactionsHistory> _transactionHistories = {};
  final List<Debtor> _filteredDebtors = [];
  final CloudStorage _cloudStorage = CloudStorage();

  @override
  void initState() {
    super.initState();
    _loadDebtors();
    _backupDatabase();
  }

  void _loadDebtors() async {
    final debtorsData = await LocalStorage().getDebtors();
    setState(() {
      _debtors.addAll(debtorsData.map((data) => Debtor(
          id: data['id'],
          name: data['name'],
          debt: data['debt'],
          debtColor: data['debt'] < 0 ? Colors.green : Colors.red)));
      _filteredDebtors
          .addAll(_debtors); // Ініціалізація списку для відображення
    });
  }

  void _addDebtor(String name, double debt) async {
    final String id = DateTime.now().toString();
    await LocalStorage().insertDebtor({
      'id': id,
      'name': name,
      'debt': debt,
    });
    setState(() {
      final newDebtor = Debtor(
          id: id,
          name: name,
          debt: debt,
          debtColor: debt < 0 ? Colors.green : Colors.red);
      _debtors.insert(0, newDebtor);
      _filteredDebtors.insert(0, newDebtor);
      _transactionHistories[id] = TransactionsHistory(id);
      _transactionHistories[id]?.addTransaction(DateTime.now(), debt);
    });
    _backupDatabase();
  }

  void _updateDebt(String id, double newDebt) async {
    final transactionDate = DateTime.now().toIso8601String();
    await LocalStorage().updateDebt(id, newDebt);
    await LocalStorage().insertAndManageTransactions({
      'id': id,
      'date': transactionDate,
      'amount': newDebt,
    });
    setState(() {
      final debtor = _debtors.firstWhere((debtor) => debtor.id == id);
      debtor.debt += newDebt;
      _transactionHistories[id]
          ?.addTransaction(DateTime.parse(transactionDate), newDebt);
      if (debtor.debt < 0) {
        debtor.debtColor = Colors.green;
      } else {
        debtor.debtColor = Colors.red;
      }
    });
    _backupDatabase();
  }

  void _viewDetails(Debtor debtor) async {
    final transactionsData = await LocalStorage().getTransactions(debtor.id);
    final history = transactionsData.map((data) {
      return MapEntry(
        DateTime.parse(data['date']),
        data['amount'],
      );
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Історія транзакцій для ${debtor.name}"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text(
                    DateFormat('dd.MM.yy HH:mm').format(entry.key.toLocal()),
                  ),
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

  void _onSearchResult(List<Debtor> results) {
    setState(() {
      _filteredDebtors
        ..clear()
        ..addAll(results);
    });
  }

  void _deleteDebtor(String id) async {
    await LocalStorage().deleteDebtor(id); // Видаляємо з БД
    setState(() {
      _debtors.removeWhere((debtor) => debtor.id == id); // Видаляємо зі списку
      _transactionHistories.remove(id); // Очищаємо історію транзакцій
      _filteredDebtors.removeWhere((debtor) => debtor.id == id);
    });
  }

  void _backupDatabase() async {
    final dbPath = await getDatabasesPath();
    final localDbPath = p.join(dbPath, 'debt_manager.db');

    await _cloudStorage.uploadDatabase(localDbPath);
    await _cloudStorage.deleteOldFiles(); // Очищення старих файлів
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SearchBarWidget(
                  debtors: _debtors,
                  onSearchResult: _onSearchResult,
                ),
                AddDebtorWidget(
                  onAddDebtor: _addDebtor,
                ),
              ],
            ),
            Expanded(
              child: DebtorListWidget(
                debtors: _filteredDebtors,
                onViewDetails: _viewDetails,
                onUpdateDebt: _updateDebt,
                onDeleteDebtor: _deleteDebtor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
