import 'package:flutter/material.dart';

class AddDebtorWidget extends StatefulWidget {
  @override
  State<AddDebtorWidget> createState() => _AddDebtorWidgetState();
}

class _AddDebtorWidgetState extends State<AddDebtorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Debtor Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Initial Debt Amount',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {},
          child: Text('Add Debtor'),
        ),
      ],
    );
  }
}
