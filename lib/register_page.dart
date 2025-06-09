import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/services/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _authController = Get.put(AuthController());

  void _register() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final cpfCnpj = _cpfCnpjController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        cpfCnpj.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar('Erro', 'Preencha todos os campos');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Erro', 'As senhas não coincidem');
      return;
    }

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
                colors: [Color(0xFF1A1A1A), Color.fromARGB(255, 69, 69, 69)],
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
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  SizedBox(height: 35),
                  Text(
                    'REGISTRAR\nNOVA CONTA',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 45),
                  _buildTextField(
                    controller: _nameController,
                    icon: Icons.person,
                    hint: 'Nome completo',
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hint: 'Email',
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _cpfCnpjController,
                    icon: Icons.assignment_ind,
                    hint: 'CPF ou CNPJ',
                  ),
                  SizedBox(height: 20),
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
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
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
                      onPressed: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
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
                      child: Text(
                        'Registrar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/login'),
                      child: Text.rich(
                        TextSpan(
                          text: 'Já possui uma conta? ',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                          children: [
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
      style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
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
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 35),
        onPressed: () => Get.back(),
      ),
    );
  }
}
