import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RxList<Map<String, dynamic>> cards = <Map<String, dynamic>>[].obs;
  final supabase = Supabase.instance.client;
  final userId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    final response = await supabase
        .from('cards')
        .select()
        .eq('user_id', userId as Object)
        .order('name');
    cards.assignAll(response);
  }

  Future<void> updateCardName(int index, String newName) async {
    final card = cards[index];
    await supabase.from('cards').update({'name': newName}).eq('id', card['id']);
    cards[index]['name'] = newName;
    cards.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Card",
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => ListView(
            padding: EdgeInsets.all(20),
            children: [
              ...cards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/detail', arguments: card['name']);
                  },
                  child: buildCard(
                    color: Color(card['color']),
                    textColor: Color(card['text_color']),
                    logo: card['name'],
                    amount: card['amount'],
                    onEdit: () => _showEditDialog(index),
                  ),
                );
              }),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.toNamed('/add', arguments: loadCards),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black),
                ),
                child: Text("Adicionar CPF ou CNPJ",
                    style: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.black)),
              )
            ],
          )),
    );
  }

  Widget buildCard({
    required Color color,
    required Color textColor,
    required String logo,
    required String amount,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(logo,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 16)),
              IconButton(
                  icon: Icon(Icons.edit, color: textColor), onPressed: onEdit),
            ],
          ),
          SizedBox(height: 20),
          Text("\$$amount",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 26)),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    final controller = TextEditingController(text: cards[index]['name']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar nome', style: TextStyle(fontFamily: 'Montserrat')),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: Get.back, child: Text('Cancelar')),
          TextButton(
            onPressed: () {
              updateCardName(index, controller.text);
              Get.back();
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
