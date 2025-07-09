import 'package:get/get.dart';

class NotasController extends GetxController {
  var notas = <Map<String, dynamic>>[].obs;

  void atualizarNotas(List<Map<String, dynamic>> novasNotas) {
    notas.assignAll(novasNotas);
  }

  void removerNota(int index) {
    notas.removeAt(index);
  }
}
