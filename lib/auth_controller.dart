import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Erro", "Usuário ou senha inválidos");
      }
    } catch (e) {
      Get.snackbar("Erro", e.toString());
    }
  }
}
