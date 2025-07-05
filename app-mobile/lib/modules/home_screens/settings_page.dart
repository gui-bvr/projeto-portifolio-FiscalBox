import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONFIGURAÇÕES',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTile(
                    icon: Icons.school,
                    title: 'Abrir Tutorial',
                    onTap: () => Get.toNamed('/tutorial'),
                  ),
                  _buildTile(
                    icon: Icons.cloud_outlined,
                    title: 'Ver status SEFAZ',
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                      final status = await _checarStatusSefaz();
                      Navigator.of(context).pop();
                      _mostrarStatusSefaz(context, status);
                    },
                  ),
                  _buildTile(
                    icon: Icons.badge,
                    title: 'Integrar certificado e-CPF',
                    onTap: () async => _selecionarCertificado(context, 'e-CPF'),
                  ),
                  _buildTile(
                    icon: Icons.business,
                    title: 'Integrar certificado e-CNPJ',
                    onTap: () async =>
                        _selecionarCertificado(context, 'e-CNPJ'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Future<void> _selecionarCertificado(BuildContext context, String tipo) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pfx', 'p12'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileBytes = await File(filePath).readAsBytes();
      final encoded = base64Encode(fileBytes);
      await secureStorage.write(key: 'cert_$tipo', value: encoded);

      _solicitarSenha(context, tipo);
    } else {
      Get.snackbar('Erro', 'Nenhum certificado selecionado.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _solicitarSenha(BuildContext context, String tipo) {
    final TextEditingController senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Senha do certificado $tipo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        content: TextField(
          controller: senhaController,
          obscureText: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Digite a senha',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white38),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final senha = senhaController.text.trim();
              if (senha.isNotEmpty) {
                await secureStorage.write(key: 'senha_$tipo', value: senha);
                Get.back();
                Get.snackbar('Sucesso', 'Certificado salvo com sucesso.',
                    backgroundColor: Colors.green, colorText: Colors.white);
              } else {
                Get.snackbar('Erro', 'Digite a senha para continuar.',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: Text('Salvar',
                style:
                    TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
          ),
        ],
      ),
    );
  }

  Future<String> _checarStatusSefaz() async {
    try {
      final response = await http
          .get(Uri.parse('https://monitorsefaz.webmaniabr.com/summary.json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['page']['status'];
        return status == 'UP'
            ? 'O SEFAZ está operando normalmente.'
            : 'O SEFAZ está inoperante no momento.';
      } else {
        return 'Erro ao consultar o status do SEFAZ. Tente novamente mais tarde.';
      }
    } catch (e) {
      return 'Erro de conexão ao consultar o status do SEFAZ.';
    }
  }

  void _mostrarStatusSefaz(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1A1A1A),
        title: Text(
          'Status SEFAZ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          status,
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
