import 'package:debtors/widgets/debtor_item_widget.dart';
import 'package:flutter/material.dart';

class DebtorListWidget extends StatefulWidget {
  @override
  State<DebtorListWidget> createState() => _DebtorListWidgetState();
}

class _DebtorListWidgetState extends State<DebtorListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Placeholder count
      itemBuilder: (context, index) {
        return DebtorItemWidget();
      },
    );
  }
}
