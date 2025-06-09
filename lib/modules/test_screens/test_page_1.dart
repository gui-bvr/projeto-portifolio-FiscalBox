import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_pin, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  "Jaraguá do Sul, SC",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildSearchBar(),
          SizedBox(height: 24),
          _buildCategories(),
          SizedBox(height: 24),
          _buildSectionTitle("Recomendadas", "Explorar"),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  title: "NFe Eletrônica",
                  subtitle: "Validadas",
                  price: "R\$24",
                  image: "assets/images/nfe1.jpg",
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildCard(
                  title: "NFC-e",
                  subtitle: "Consumidor",
                  price: "R\$20",
                  image: "assets/images/nfe2.jpg",
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          _buildSectionTitle("Baseado na sua localização", "Ver mapa"),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset("assets/images/map_example.jpg"),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar nota fiscal...",
                border: InputBorder.none,
              ),
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryItem(Icons.receipt_long, "Notas", isSelected: true),
          SizedBox(width: 12),
          _buildCategoryItem(Icons.store, "Comércios"),
          SizedBox(width: 12),
          _buildCategoryItem(Icons.person, "CPF/CNPJ"),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label,
      {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.grey),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          action,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String price,
    required String image,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.favorite_border, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
