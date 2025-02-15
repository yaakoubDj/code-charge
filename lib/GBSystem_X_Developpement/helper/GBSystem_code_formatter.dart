import 'package:flutter/services.dart';

class CodeInputFormatter extends TextInputFormatter {
  final int theme;

  CodeInputFormatter(this.theme);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(' ', '');

    String formatted = '';
    if (theme == 0) {
      // Case 0: Format as XXXX XXXX XXXX XXX
      digitsOnly = digitsOnly.substring(0, digitsOnly.length.clamp(0, 15));
      formatted = digitsOnly
          .replaceAllMapped(
            RegExp(r'(\d{1,4})(?=(\d{1,4})|$)'),
            (Match match) => '${match.group(0)} ',
          )
          .trimRight();
    } else if (theme == 1) {
      // Case 1: No spaces, max 14 digits
      digitsOnly = digitsOnly.substring(0, digitsOnly.length.clamp(0, 14));
      formatted = digitsOnly;
    } else if (theme == 2) {
      // Case 2: Single space in the middle, max 14 digits
      digitsOnly = digitsOnly.substring(0, digitsOnly.length.clamp(0, 14));
      formatted = digitsOnly.replaceAllMapped(
        RegExp(r'^(\d{1,7})(\d{1,7})?$'),
        (Match match) =>
            '${match.group(1) ?? ""} ${(match.group(2) ?? "").trim()}',
      );
    }

    // Handle empty text or ensure the selection offset is valid
    int selectionOffset =
        formatted.isNotEmpty ? formatted.length.clamp(0, formatted.length) : 0;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}
