import 'package:debtors/models/debtor.dart';
import 'package:flutter/material.dart';

class DebtorItemWidget extends StatefulWidget {
  final Debtor debtor;
  final ValueChanged<double> onUpdateDebt;
  final VoidCallback onViewDetails;

  DebtorItemWidget(
      {required this.debtor,
      required this.onUpdateDebt,
      required this.onViewDetails});

  @override
  State<DebtorItemWidget> createState() => _DebtorItemWidgetState();
}

class _DebtorItemWidgetState extends State<DebtorItemWidget> {
  final TextEditingController _transactionController = TextEditingController();

  void _updateDebt() {
    final newDebt = double.tryParse(_transactionController.text);
    if (newDebt != null) {
      widget.onUpdateDebt(newDebt);
      _transactionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onViewDetails,
              child: Text(
                widget.debtor.name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Text('Current Debt: ${widget.debtor.debt.toStringAsFixed(2)}'),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _transactionController,
                    decoration: InputDecoration(
                      labelText: 'Update Debt',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _updateDebt,
                  child: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
