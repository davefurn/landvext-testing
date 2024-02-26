import 'package:landvest/src/core/constants/imports.dart';

class MoneyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int selectionIndex = newValue.selection.end;

    String value = newValue.text;
    value = value.replaceAll(',', '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    final int newSelectionIndex =
        selectionIndex + (value.length - newValue.text.length);
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
