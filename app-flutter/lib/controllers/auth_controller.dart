import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../themes/app_snackbar.dart';

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
        AppSnackbar.error('Verifique seu e-mail para confirmar a conta');
      } else {
        AppSnackbar.success('Cadastro realizado com sucesso!');
        Get.offAllNamed('/home');
      }
    } catch (e) {
      AppSnackbar.error('Erro ao registrar: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      if (response.user != null) {
        AppSnackbar.success('Login realizado com sucesso');
        Get.offAllNamed('/home');
      } else {
        AppSnackbar.error('Erro: usuário retornado como null');
      }
    } on AuthException catch (e) {
      AppSnackbar.error('AuthException: ${e.message}');
    } catch (e) {
      AppSnackbar.error('Erro desconhecido: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}
