import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Super Card",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          buildCard(
            color: Colors.black,
            textColor: Colors.white,
            logo: "VISA",
            amount: "1,260.28",
            lastDigits: "7735",
            exp: "08 / 28",
          ),
          SizedBox(height: 16),
          buildCard(
            color: Color(0xFFF3B18C),
            textColor: Colors.black,
            logo: "MASTERCARD",
            amount: "1,180.49",
            lastDigits: "7998",
            exp: "08 / 28",
          ),
          SizedBox(height: 16),
          buildCard(
            color: Color(0xFFE8EFFA),
            textColor: Colors.black,
            logo: "VISA",
            amount: "865.39",
            lastDigits: "7782",
            exp: "08 / 28",
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {},
            child: Text(
              "+ Add Card",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.crop_free), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }

  Widget buildCard({
    required Color color,
    required Color textColor,
    required String logo,
    required String amount,
    required String lastDigits,
    required String exp,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            logo,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "\$$amount",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 26,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "****  ****  ****",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: textColor,
                ),
              ),
              Text(
                lastDigits,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              exp,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: textColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
