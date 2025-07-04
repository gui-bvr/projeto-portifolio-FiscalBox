import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CpfCnpjFormatter {
  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _cnpjMask = MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

  late MaskTextInputFormatter _activeMask;

  CpfCnpjFormatter() {
    _activeMask = _cpfMask;
  }

  List<TextInputFormatter> get formatters => [_activeMask];

  void updateMask(String value) {
    final numeric = value.replaceAll(RegExp(r'\D'), '');
    _activeMask = numeric.length <= 11 ? _cpfMask : _cnpjMask;
  }
}
