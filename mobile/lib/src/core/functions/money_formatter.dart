import 'package:landvext/src/core/constants/imports.dart';

class MoneyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int selectionIndex = newValue.selection.end;

    String value = newValue.text
        .replaceAll(',', '')
        .replaceAll(LandConstants.regexName, ',');
    final int newSelectionIndex =
        selectionIndex + (value.length - newValue.text.length);
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
