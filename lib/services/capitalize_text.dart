import 'package:flutter/services.dart';

class CapitalizeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Перетворюємо першу літеру на велику
    if (newText.isNotEmpty) {
      newText = newText[0].toUpperCase() + newText.substring(1);
    }

    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}
