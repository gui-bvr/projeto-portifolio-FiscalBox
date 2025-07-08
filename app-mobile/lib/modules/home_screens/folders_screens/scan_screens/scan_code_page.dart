import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/api_service.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  final codigoController = TextEditingController();
  final apiService = ApiService();

  void _adicionarNota() async {
    final codigo = codigoController.text.trim();
    if (codigo.length != 44) {
      Get.snackbar('Erro', 'A chave de acesso deve conter 44 dígitos.');
      return;
    }

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      barrierDismissible: false,
    );

    try {
      await Future.delayed(const Duration(seconds: 2));
      await apiService.fetchNotaFiscal(codigo);
      Get.back();
      _mostrarDialogo('Nota adicionada com sucesso!', true);
    } catch (e) {
      Get.back();
      _mostrarDialogo('Erro ao adicionar a nota!', false);
    }
  }

  void _mostrarDialogo(String mensagem, bool sucesso) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          mensagem,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scanearQRCode() {
    Get.toNamed('/scan_qr_code');
  }

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 35),
                  const Text(
                    'ADICIONAR POR CÓDIGO/\nCHAVE DE ACESSO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: codigoController,
                    keyboardType: TextInputType.number,
                    maxLength: 44,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      prefixIcon:
                          const Icon(Icons.numbers, color: Colors.white70),
                      hintText: 'Chave de acesso (44 dígitos)',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'O código da nota fiscal, também conhecido como chave de acesso, é um número de 44 dígitos que identifica cada Nota Fiscal Eletrônica (NF-e).'
                    ' Ele pode ser encontrado próximo ao código de barras, ou QR Code da Nota, ou geralmente em algum dos cantos superiores ou inferiores.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _adicionarNota,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _scanearQRCode,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Escanear QR Code',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }
}
