import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class ScanQrCodePage extends StatelessWidget {
  const ScanQrCodePage({super.key});

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
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          AiBarcodeScanner(
            controller: MobileScannerController(
              formats: [BarcodeFormat.qrCode],
              detectionSpeed: DetectionSpeed.normal,
            ),
            validator: (capture) {
              final value = capture.barcodes.first.rawValue;
              return value != null && value.length > 10;
            },
            onDetect: (capture) {
              final value = capture.barcodes.firstOrNull?.rawValue;
              if (value != null) {
                Navigator.of(context).pop(value);
              }
            },
            overlayConfig: const ScannerOverlayConfig(
              borderColor: Colors.white,
              successColor: Colors.greenAccent,
              errorColor: Colors.redAccent,
              borderRadius: 12,
              cornerLength: 32,
              scannerBorder: ScannerBorder.corner,
            ),
            appBarBuilder: (context, controller) {
              return AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                title: const Text(
                  "Escanear QR Code",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
