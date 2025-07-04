import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/saudacao.dart';
import 'home_controller.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomeController());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final saudacaoTexto = saudacao();
    final user = Supabase.instance.client.auth.currentUser;
    final nome = user?.userMetadata?['full_name'] ?? 'Usuário';
    final email = user?.email ?? 'email@exemplo.com';

    final pages = [
      _buildHomeContent(saudacaoTexto),
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
    );
  }

  Widget _buildHomeContent(String saudacaoTexto) {
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
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
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
                    itemCount: controller.documentos.length,
                    itemBuilder: (context, index) {
                      final doc = controller.documentos[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/detalhes', arguments: doc);
                        },
                        child: buildCard(
                          tipo: doc['tipo']!,
                          numero: doc['numero']!,
                          color: const Color(0xFFE8EFFA),
                          textColor: Colors.black,
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
              onPressed: () {},
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
