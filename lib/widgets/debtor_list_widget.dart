import 'package:debtors/models/debtor.dart';
import 'package:debtors/widgets/debtor_item_widget.dart';
import 'package:flutter/material.dart';

class DebtorListWidget extends StatelessWidget {
  final List<Debtor> debtors;
  final ValueChanged<Debtor> onViewDetails;
  final Function(String, double) onUpdateDebt;
  final Function(String) onDeleteDebtor;

  const DebtorListWidget({
    super.key,
    required this.debtors,
    required this.onViewDetails,
    required this.onUpdateDebt,
    required this.onDeleteDebtor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: debtors.length,
      itemBuilder: (context, index) {
        return DebtorItemWidget(
          debtor: debtors[index],
          onUpdateDebt: (newDebt) => onUpdateDebt(debtors[index].id, newDebt),
          onViewDetails: () => onViewDetails(debtors[index]),
          onDeleteDebtor: onDeleteDebtor,
        );
      },
    );
  }
}
