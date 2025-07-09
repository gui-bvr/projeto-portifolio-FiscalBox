import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../services/local_db_service.dart';

class DetalhesNotaPage extends StatelessWidget {
  final Map<String, dynamic> rawNota = Get.arguments;
  final Map<String, dynamic> notaJson =
      jsonDecode(Get.arguments['jsonCompleto']);
  final _dbService = LocalDbService();

  DetalhesNotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emitente = notaJson['emitente'];
    final destinatario = notaJson['destinatario'];
    final itens = List<Map<String, dynamic>>.from(notaJson['itens'] ?? []);
    final data = notaJson['dataEmissao'] ?? '';
    final valor = notaJson['valorTotal'] ?? 0.0;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 35),
                  const Text(
                    'DETALHES DA NOTA',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildField('Emitente:',
                      '${emitente['nomeFantasia'] ?? emitente['nome']}'),
                  _buildField('Destinatário:',
                      '${destinatario['nome']} (${destinatario['cpfCnpj']})'),
                  _buildField('Data de emissão:', data),
                  _buildField(
                      'Valor total:', 'R\$ ${valor.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  const Text(
                    'Itens:',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: itens.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white24),
                      itemBuilder: (context, index) {
                        final item = itens[index];
                        return Text(
                          '${item['quantidade']}x ${item['descricao']} — R\$ ${item['valorTotalItem'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomButton(
              icon: Icons.delete,
              label: 'Excluir',
              color: Colors.redAccent,
              onTap: () async {
                await _dbService.deletarNota(rawNota['chaveAcesso']);
                Get.back();
                Get.snackbar('Nota removida', 'A nota fiscal foi excluída.',
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            _bottomButton(
              icon: Icons.share,
              label: 'Compartilhar',
              color: Colors.white,
              onTap: () async {
                await Share.share(jsonEncode(notaJson),
                    subject: 'Nota Fiscal - FiscalBox');
              },
            ),
            _bottomButton(
              icon: Icons.download,
              label: 'Exportar',
              color: Colors.white,
              onTap: () {
                Get.snackbar('Em breve', 'Função de exportar será adicionada.',
                    backgroundColor: Colors.white10,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A1A), Color(0xFF2E2E2E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),
      ],
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

  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 14,
              )),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white70,
                fontSize: 14,
              )),
        ],
      ),
    );
  }

  Widget _bottomButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
