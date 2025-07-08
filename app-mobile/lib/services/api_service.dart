// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/nota_fiscal.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:3000';

  Future<NotaFiscal> fetchNotaFiscal(String chaveAcesso) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/nota-fiscal/$chaveAcesso'));

    if (response.statusCode == 200) {
      return NotaFiscal.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception(
          'Nota fiscal não encontrada para a chave de acesso: $chaveAcesso');
    } else {
      throw Exception(
          'Falha ao carregar a nota fiscal: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> uploadCertificado(
      String certificadoBase64, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/upload-certificado'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'certificadoBase64': certificadoBase64,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['message'] ?? 'Certificado enviado com sucesso.';
    } else {
      final Map<String, dynamic> errorBody = json.decode(response.body);
      throw Exception(
          'Falha ao enviar certificado: ${errorBody['message'] ?? 'Erro desconhecido'}');
    }
  }
}
