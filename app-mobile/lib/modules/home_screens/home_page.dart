import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/greeting.dart';
import '../../controllers/home_controller.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomeController(), permanent: true);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.carregarPastas();
  }

  @override
  Widget build(BuildContext context) {
    final saudacaoTexto = saudacao();
    final user = Supabase.instance.client.auth.currentUser;
    final nome = user?.userMetadata?['full_name'] ?? 'Usuário';
    final email = user?.email ?? 'email@exemplo.com';

    final pages = [
      _buildHomeContent(saudacaoTexto, nome),
      Placeholder(),
      SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      drawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.black.withOpacity(0.4),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(CupertinoIcons.home, 'Home', '/home'),
                  _buildDrawerItem(Icons.help_outline, 'Ajuda', '/ajuda'),
                  _buildDrawerItem(CupertinoIcons.info, 'Sobre', '/sobre'),
                  ListTile(
                    leading: const Icon(CupertinoIcons.return_icon,
                        color: Colors.white),
                    title: const Text('Sair',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Montserrat')),
                    onTap: () async {
                      await Supabase.instance.client.auth.signOut();
                      Get.offAllNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.add, color: Colors.black),
              onPressed: () => Get.toNamed('/adicionar'),
            )
          : null,
    );
  }

  Widget _buildHomeContent(String saudacaoTexto, String nome) {
    return Stack(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      saudacaoTexto,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.pastas.length,
                    itemBuilder: (context, index) {
                      final pasta = controller.pastas[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/pasta', arguments: pasta.toMap());
                        },
                        child: buildCard(
                          tipo: pasta.tipo,
                          numero: pasta.numero,
                          color: const Color(0xFFE8EFFA),
                          textColor: Colors.black,
                          onMorePressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              backgroundColor: Colors.grey[900],
                              constraints: const BoxConstraints(minHeight: 200),
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.edit,
                                        color: Colors.white),
                                    title: const Text(
                                      'Editar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Get.back();
                                      Get.toNamed(
                                        '/editar',
                                        arguments: {
                                          'tipo': pasta.tipo,
                                          'numero': pasta.numero,
                                          'index': index,
                                        },
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete,
                                        color: Colors.white),
                                    title: const Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Get.back();
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: Colors.grey[900],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          title: const Text(
                                            'Tem certeza?',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: const Text(
                                            'Deseja realmente excluir esta pasta?\nIsso apagará todos os dados.',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white70,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await controller
                                                    .excluirPasta(index);
                                                Get.back();
                                              },
                                              child: const Text(
                                                'Continuar',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
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
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
      ),
      onTap: () => Get.toNamed(route),
    );
  }

  Widget buildCard({
    required String tipo,
    required String numero,
    required Color color,
    required Color textColor,
    VoidCallback? onMorePressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.more_vert, color: textColor),
              onPressed: onMorePressed,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tipo,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                numero,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
