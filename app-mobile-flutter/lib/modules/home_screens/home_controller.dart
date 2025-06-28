import 'package:get/get.dart';

class HomeController extends GetxController {
  var documentos = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simula o primeiro cartão automaticamente após cadastro
    documentos.add({
      "tipo": "CPF",
      "numero": "123.456.789-00",
    });
  }

  void adicionarDocumento(String tipo, String numero) {
    documentos.add({"tipo": tipo, "numero": numero});
  }
}
