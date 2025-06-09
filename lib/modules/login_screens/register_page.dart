import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../controllers/auth_controller.dart';
import '../../themes/app_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _storage = GetStorage();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _authController = Get.find<AuthController>();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _useCnpj = false;

  bool _isValidFullName(String name) {
    final parts = name.trim().split(' ');
    if (parts.length < 2) return false;
    for (var part in parts) {
      if (part.length < 2) return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;
    List<int> digits = cpf.split('').map(int.parse).toList();
    for (int i = 9; i < 11; i++) {
      int sum = 0;
      for (int j = 0; j < i; j++) {
        sum += digits[j] * ((i + 1) - j);
      }
      int mod = (sum * 10) % 11;
      if (mod == 10) mod = 0;
      if (mod != digits[i]) return false;
    }
    return true;
  }

  bool _isValidCnpj(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.length != 14 || RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;
    List<int> digits = cnpj.split('').map(int.parse).toList();
    List<int> calc1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    List<int> calc2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum1 =
        List.generate(12, (i) => digits[i] * calc1[i]).reduce((a, b) => a + b);
    int check1 = sum1 % 11;
    check1 = check1 < 2 ? 0 : 11 - check1;
    int sum2 =
        List.generate(13, (i) => digits[i] * calc2[i]).reduce((a, b) => a + b);
    int check2 = sum2 % 11;
    check2 = check2 < 2 ? 0 : 11 - check2;
    return check1 == digits[12] && check2 == digits[13];
  }

  void _register() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final cpfCnpj = _cpfCnpjController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final docOnlyNumbers = cpfCnpj.replaceAll(RegExp(r'\D'), '');

    if (name.isEmpty ||
        email.isEmpty ||
        cpfCnpj.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      AppSnackbar.error('Preencha todos os campos');
      return;
    }

    if (!_isValidFullName(name)) {
      AppSnackbar.error('Informe seu nome completo corretamente');
      return;
    }

    if (!_isValidEmail(email)) {
      AppSnackbar.error('Email inválido');
      return;
    }

    if (!_useCnpj && !_isValidCpf(docOnlyNumbers)) {
      AppSnackbar.error('CPF inválido');
      return;
    }

    if (_useCnpj && !_isValidCnpj(docOnlyNumbers)) {
      AppSnackbar.error('CNPJ inválido');
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.error('As senhas não coincidem');
      return;
    }

    _storage.write('nome', name);
    _storage.write('email', email);
    _storage.write('documento', cpfCnpj);

    _authController.signUp(email, password, name, cpfCnpj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF1A1A1A),
                  Color.fromARGB(255, 69, 69, 69)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 35),
                  const Text(
                    'REGISTRAR\nNOVA CONTA',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 45),
                  _buildTextField(
                    controller: _nameController,
                    icon: Icons.person,
                    hint: 'Nome completo',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hint: 'Email',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cpfCnpjController,
                    onChanged: (value) {
                      final onlyNumbers = value.replaceAll(RegExp(r'\D'), '');
                      String masked = '';
                      if (onlyNumbers.length > 11) {
                        _useCnpj = true;
                        masked = _cnpjMask.maskText(onlyNumbers);
                      } else {
                        _useCnpj = false;
                        masked = _cpfMask.maskText(onlyNumbers);
                      }
                      setState(() {
                        _cpfCnpjController.value = TextEditingValue(
                          text: masked,
                          selection:
                              TextSelection.collapsed(offset: masked.length),
                        );
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontFamily: 'Montserrat', color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.assignment_ind,
                          color: Colors.white70),
                      hintText: 'CPF ou CNPJ',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hint: 'Senha',
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    hint: 'Confirmar senha',
                    obscure: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/login'),
                      child: Text.rich(
                        TextSpan(
                          text: 'Já possui uma conta? ',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 18),
                          children: const [
                            TextSpan(
                              text: ' Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35),
        onPressed: () => Get.back(),
      ),
    );
  }
}
