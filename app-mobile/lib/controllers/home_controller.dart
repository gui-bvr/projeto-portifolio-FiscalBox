import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final _storage = GetStorage();
  var pastas = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarPastas();
  }

  void carregarPastas() {
    final storedDocs = _storage.read<List>('pastas') ?? [];
    pastas.value = List<Map<String, String>>.from(storedDocs);
  }

  void adicionarPasta(Map<String, String> pasta) {
    pastas.insert(0, pasta);
    _salvarNoStorage();
  }

  void removerPasta(String numero) {
    pastas.removeWhere((doc) => doc['numero'] == numero);
    _salvarNoStorage();
  }

  void _salvarNoStorage() {
    _storage.write('documentos', pastas);
  }
}
