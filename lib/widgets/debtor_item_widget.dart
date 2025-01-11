import 'package:debtors/models/debtor.dart';
import 'package:flutter/material.dart';

class DebtorItemWidget extends StatefulWidget {
  final Debtor debtor;
  final ValueChanged<double> onUpdateDebt;
  final VoidCallback onViewDetails;
  final Function(String) onDeleteDebtor;
  final Color debtColor;

  const DebtorItemWidget({
    super.key,
    required this.debtor,
    required this.onUpdateDebt,
    required this.onViewDetails,
    required this.onDeleteDebtor,
    required this.debtColor,
  });

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

  void _deleteDebtor() {
    if (widget.debtor.debt == 0) {
      widget.onDeleteDebtor(widget.debtor.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.debtor.name,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 60,
                  width: 150,
                  child: TextField(
                    controller: _transactionController,
                    decoration: InputDecoration(
                      labelText: 'Сума',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Задайте бажаний колір
                        fontSize:
                            16, // Опційно, ви можете змінити розмір шрифта
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: _updateDebt,
                  child: Text('ОК'),
                ),
                ElevatedButton(
                  onPressed: widget.debtor.debt == 0 ? _deleteDebtor : null,
                  child: Icon(
                    Icons.delete,
                    color: widget.debtor.debt == 0 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.debtor.debt.toStringAsFixed(2),
                  style: TextStyle(
                    color: widget.debtColor,
                    fontSize: 18.0,
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.onViewDetails,
                  child: Icon(Icons.question_mark_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
