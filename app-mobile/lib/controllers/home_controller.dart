import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pasta_model.dart';

class HomeController extends GetxController {
  final pastas = <PastaModel>[].obs;
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
      (response as List).map((item) => PastaModel.fromMap(item)).toList(),
    );
  }

  Future<void> adicionarPasta(PastaModel novaPasta) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase.from('pastas').insert({
      'user_id': user.id,
      'tipo': novaPasta.tipo,
      'numero': novaPasta.numero,
    }).select();

    final data = response.first;
    pastas.add(PastaModel.fromMap(data));
  }

  Future<void> editarPasta(int index, PastaModel pastaAtualizada) async {
    final id = pastas[index].id;
    if (id.isEmpty) return;

    await supabase.from('pastas').update({
      'tipo': pastaAtualizada.tipo,
      'numero': pastaAtualizada.numero,
    }).eq('id', id);

    pastas[index] = pastaAtualizada;
  }

  Future<void> excluirPasta(int index) async {
    final id = pastas[index].id;
    if (id.isEmpty) return;

    await supabase.from('pastas').delete().eq('id', id);
    pastas.removeAt(index);
  }
}
