import 'package:debtors/models/debtor.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final List<Debtor> debtors;
  final Function(List<Debtor>) onSearchResult;

  const SearchBarWidget({
    super.key,
    required this.debtors,
    required this.onSearchResult,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String _searchQuery = '';

  void _filterDebtors(String query) {
    setState(() {
      _searchQuery = query;
    });

    final filteredDebtors = widget.debtors
        .where(
            (debtor) => debtor.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    widget.onSearchResult(filteredDebtors);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Знайти боржника',
        border: OutlineInputBorder(),
      ),
      onChanged: _filterDebtors,
    );
  }
}
