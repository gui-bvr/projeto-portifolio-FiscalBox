import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../controllers/home_controller.dart';
import '../../models/pasta_model.dart';

class EditFolderPage extends StatefulWidget {
  const EditFolderPage({super.key});

  @override
  State<EditFolderPage> createState() => _EditFolderPageState();
}

class _EditFolderPageState extends State<EditFolderPage> {
  final tipoController = TextEditingController();
  final numeroController = TextEditingController();
  final controller = Get.find<HomeController>();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  int? pastaIndex;
  late PastaModel pasta;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    pasta = PastaModel.fromMap(args);

    tipoController.text = pasta.tipo;
    numeroController.text = pasta.numero;

    pastaIndex = controller.pastas.indexWhere(
      (p) => p.tipo == pasta.tipo && p.numero == pasta.numero,
    );
  }

  void _editarPasta() {
    final tipo = tipoController.text.trim();
    final numero = numeroController.text.trim();

    if (tipo.isEmpty || numero.isEmpty) {
      Get.snackbar('Erro', 'Preencha todos os campos.');
      return;
    }

    if (pastaIndex != null && pastaIndex! >= 0) {
      final pastaAtualizada = PastaModel(
        id: pasta.id,
        tipo: tipo,
        numero: numero,
      );
      controller.editarPasta(pastaIndex!, pastaAtualizada);
    }

    Get.back();
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 35),
                  const Text(
                    'EDITAR PASTA',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 45),
                  _buildTextField(
                    controller: tipoController,
                    icon: Icons.description,
                    hint: 'Nome',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: numeroController,
                    onChanged: (value) {
                      final onlyNumbers = value.replaceAll(RegExp(r'\D'), '');
                      String masked = '';
                      if (onlyNumbers.length > 11) {
                        masked = _cnpjMask.maskText(onlyNumbers);
                      } else {
                        masked = _cpfMask.maskText(onlyNumbers);
                      }
                      setState(() {
                        numeroController.value = TextEditingValue(
                          text: masked,
                          selection:
                              TextSelection.collapsed(offset: masked.length),
                        );
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.numbers, color: Colors.white70),
                      hintText: 'Número de CPF ou CNPJ',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _editarPasta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Montserrat', color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
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
