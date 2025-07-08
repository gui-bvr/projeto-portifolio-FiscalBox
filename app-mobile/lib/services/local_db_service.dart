import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas_fiscais (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pasta TEXT,
            json TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertNotaFiscal(
      Map<String, dynamic> notaJson, String pasta) async {
    final db = await database;
    await db.insert(
      'notas_fiscais',
      {
        'pasta': pasta,
        'json': jsonEncode(notaJson),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotasPorPasta(String pasta) async {
    final db = await database;
    return await db.query(
      'notas_fiscais',
      where: 'pasta = ?',
      whereArgs: [pasta],
    );
  }
}
