import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final pastas = <Map<String, String>>[].obs;
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    carregarPastas();
  }

  Future<void> carregarPastas() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('pastas')
        .select()
        .eq('user_id', user.id)
        .order('id', ascending: true);

    pastas.assignAll(
      (response as List).map<Map<String, String>>((item) {
        return {
          'id': item['id'].toString(),
          'tipo': item['tipo'] ?? '',
          'numero': item['numero'] ?? '',
        };
      }).toList(),
    );
  }

  Future<void> adicionarPasta(Map<String, String> novaPasta) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase.from('pastas').insert({
      'user_id': user.id,
      'tipo': novaPasta['tipo'],
      'numero': novaPasta['numero'],
    }).select();

    final data = response.first;

    pastas.add({
      'id': data['id'].toString(),
      'tipo': data['tipo'] ?? '',
      'numero': data['numero'] ?? '',
    });
  }

  Future<void> editarPasta(
      int index, Map<String, String> pastaAtualizada) async {
    final id = pastas[index]['id'];
    if (id == null) return;

    await supabase.from('pastas').update({
      'tipo': pastaAtualizada['tipo'],
      'numero': pastaAtualizada['numero'],
    }).eq('id', id);

    pastas[index] = {
      'id': id,
      'tipo': pastaAtualizada['tipo'] ?? '',
      'numero': pastaAtualizada['numero'] ?? '',
    };
  }

  Future<void> excluirPasta(int index) async {
    final id = pastas[index]['id'];
    if (id == null) return;

    await supabase.from('pastas').delete().eq('id', id);
    pastas.removeAt(index);
  }
}
