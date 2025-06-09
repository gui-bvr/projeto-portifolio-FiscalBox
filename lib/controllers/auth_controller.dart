import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;

  Future<void> signUp(String email, String password, String nomeCompleto,
      String cpfOuCnpj) async {
    try {
      isLoading.value = true;
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': nomeCompleto,
          'document': cpfOuCnpj,
        },
      );

      if (response.user == null) {
        Get.snackbar('Erro', 'Verifique seu e-mail para confirmar a conta');
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Erro ao registrar', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await supabase.auth.signInWithPassword(email: email, password: password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Erro ao entrar', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}
