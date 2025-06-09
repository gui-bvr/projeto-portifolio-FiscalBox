import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void error(String message, {String title = 'Erro'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent.shade200,
      icon: Icons.error_outline,
    );
  }

  static void success(String message, {String title = 'Sucesso'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.blueGrey.shade700,
      icon: Icons.info_outline,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white.withOpacity(0.95),
        ),
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 16,
      margin: EdgeInsets.all(16),
      icon: Icon(icon, color: Colors.white, size: 26),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 250),
      isDismissible: true,
      shouldIconPulse: false,
    );
  }
}
