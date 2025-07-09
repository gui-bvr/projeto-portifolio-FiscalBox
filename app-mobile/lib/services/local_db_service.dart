import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;

    final path = join(await getDatabasesPath(), 'notas.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chaveAcesso TEXT UNIQUE,
            jsonCompleto TEXT,
            pastaTipo TEXT,
            pastaNumero TEXT
          )
        ''');
      },
    );
  }

  static Future<void> inserirNota({
    required String chaveAcesso,
    required Map<String, dynamic> json,
    required String pastaTipo,
    required String pastaNumero,
  }) async {
    await init();

    await _db!.insert(
      'notas',
      {
        'chaveAcesso': chaveAcesso,
        'jsonCompleto': jsonEncode(json),
        'pastaTipo': pastaTipo,
        'pastaNumero': pastaNumero,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> buscarNotasPorPasta(
      String pastaTipo, String pastaNumero) async {
    await init();

    return await _db!.query(
      'notas',
      where: 'pastaTipo = ? AND pastaNumero = ?',
      whereArgs: [pastaTipo, pastaNumero],
    );
  }

  Future<List<Map<String, dynamic>>> getNotasPorPasta(String numero) async {
    await init();

    final result = await _db!.query(
      'notas',
      where: 'pastaNumero = ?',
      whereArgs: [numero],
    );

    return result;
  }

  Future<void> insertNotaFiscal(
      Map<String, Object?> json, String pastaNumero) async {
    await LocalDbService.init();

    await _db!.insert(
      'notas',
      {
        'chaveAcesso': json['chaveAcesso'],
        'jsonCompleto': jsonEncode(json),
        'pastaTipo': '',
        'pastaNumero': pastaNumero,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletarNota(String chaveAcesso) async {
    await init();
    await _db!.delete(
      'notas',
      where: 'chaveAcesso = ?',
      whereArgs: [chaveAcesso],
    );
  }
}
