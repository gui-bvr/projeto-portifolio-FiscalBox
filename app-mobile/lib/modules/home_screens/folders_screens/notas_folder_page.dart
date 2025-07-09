import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/local_db_service.dart';

class NotasController extends GetxController {
  var notas = <Map<String, dynamic>>[].obs;

  void atualizarNotas(List<Map<String, dynamic>> novasNotas) {
    notas.assignAll(novasNotas);
  }

  void removerNota(int index) {
    notas.removeAt(index);
  }
}

class NotaFiscalPastaPage extends StatefulWidget {
  final Map<String, String> pasta =
      Map<String, String>.from(Get.arguments ?? {});

  NotaFiscalPastaPage({super.key});

  @override
  State<NotaFiscalPastaPage> createState() => _NotaFiscalPastaPageState();
}

class _NotaFiscalPastaPageState extends State<NotaFiscalPastaPage> {
  final LocalDbService _dbService = LocalDbService();
  final NotasController notasController = Get.put(NotasController());

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  Future<void> _carregarNotas() async {
    final notas =
        await _dbService.getNotasPorPasta(widget.pasta['numero'] ?? '');
    notasController.atualizarNotas(notas);
  }

  void _mostrarOpcoesAdicao(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.grey[900],
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.code, color: Colors.white),
            title: const Text(
              'Adicionar por código',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Get.toNamed('/scan_code', arguments: widget.pasta)?.then((_) {
                _carregarNotas();
                /*Get.snackbar(
                  'Nota adicionada',
                  'A nota foi salva com sucesso!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );*/
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code, color: Colors.white),
            title: const Text(
              'Adicionar por QR Code',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.toNamed('/scan_qr_code');
            },
          ),
        ],
      ),
    );
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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pasta['tipo'] ?? 'Notas Fiscais',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 28),
                        onPressed: () => _mostrarOpcoesAdicao(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: notasController.notas.length,
                      itemBuilder: (context, index) {
                        final rawJson =
                            notasController.notas[index]['jsonCompleto'];
                        final nota = rawJson != null ? jsonDecode(rawJson) : {};
                        final emitente = nota['emitente']?['nomeFantasia'] ??
                            nota['emitente']?['nome'] ??
                            'Emitente desconhecido';
                        final data =
                            nota['dataEmissao']?.toString().substring(0, 10) ??
                                '';
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              '/detalhes_nota',
                              arguments: notasController.notas[index],
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EFFA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  emitente,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Emitida em: $data',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'R\$ ${nota['valorTotal'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
