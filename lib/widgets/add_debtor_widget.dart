import 'package:flutter/material.dart';

class AddDebtorWidget extends StatefulWidget {
  final void Function(String name, double initialDebt) onAddDebtor;

  AddDebtorWidget({required this.onAddDebtor});

  @override
  _AddDebtorWidgetState createState() => _AddDebtorWidgetState();
}

class _AddDebtorWidgetState extends State<AddDebtorWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController debtController = TextEditingController();

  void handleAddDebtor() {
    final name = nameController.text.trim();
    final debt = double.tryParse(debtController.text);
    if (name.isNotEmpty && debt != null) {
      widget.onAddDebtor(name, debt);
      nameController.clear();
      debtController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Прізвище"),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: debtController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Початковий борг"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: handleAddDebtor,
          ),
        ],
      ),
    );
  }
}
