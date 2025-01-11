import 'package:debtors/services/capitalize_text.dart';
import 'package:flutter/material.dart';

class AddDebtorWidget extends StatefulWidget {
  final void Function(String name, double initialDebt) onAddDebtor;

  const AddDebtorWidget({super.key, required this.onAddDebtor});

  @override
  _AddDebtorWidgetState createState() => _AddDebtorWidgetState();
}

class _AddDebtorWidgetState extends State<AddDebtorWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController debtController = TextEditingController();

  void _showAddDebtorDialog() {
    String name = '';
    String debt = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Прізвище'),
                inputFormatters: [CapitalizeTextInputFormatter()],
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Сума'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  debt = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && double.tryParse(debt) != null) {
                  widget.onAddDebtor(name, double.parse(debt));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Додати'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(onPressed: _showAddDebtorDialog, icon: Icon(Icons.add)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
