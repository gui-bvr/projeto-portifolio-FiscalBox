String saudacao() {
  final hora = DateTime.now().hour;
  if (hora < 12) {
    return 'Bom dia';
  } else if (hora < 18) {
    return 'Boa tarde';
  } else {
    return 'Boa noite';
  }
}
