import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCardPage extends StatelessWidget {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final supabase = Supabase.instance.client;
  final userId = Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    final Function refreshCards = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Novo CPF ou CNPJ",
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nome")),
            TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Valor"),
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await supabase.from('cards').insert({
                  'user_id': userId,
                  'name': nameController.text,
                  'amount': amountController.text,
                  'color': Colors.grey[300]!.value,
                  'text_color': Colors.black.value,
                });
                refreshCards(); // recarrega após inserir
                Get.back();
              },
              child:
                  Text("Adicionar", style: TextStyle(fontFamily: 'Montserrat')),
            ),
          ],
        ),
      ),
    );
  }
}
