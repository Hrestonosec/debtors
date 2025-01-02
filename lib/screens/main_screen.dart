import 'package:flutter/material.dart';
import 'package:debtors/widgets/search_bar_widget.dart';
import 'package:debtors/widgets/add_debtor_widget.dart';
import 'package:debtors/widgets/debtor_list_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(),
            SizedBox(height: 16.0),
            AddDebtorWidget(),
            SizedBox(height: 16.0),
            Expanded(child: DebtorListWidget()),
          ],
        ),
      ),
    );
  }
}
