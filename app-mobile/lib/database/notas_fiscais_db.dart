import 'package:portifolio_fiscal_box/models/nota_fiscal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'fiscalbox.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas_fiscais (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT,
            valor REAL,
            chave_acesso TEXT,
            pasta_id TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertNotaFiscal(
    NotaFiscal nota,
    String s, {
    required String tipo,
    required double valor,
    required String chaveAcesso,
    required String pastaId,
  }) async {
    final db = await database;
    await db.insert(
      'notas_fiscais',
      {
        'tipo': tipo,
        'valor': valor,
        'chave_acesso': chaveAcesso,
        'pasta_id': pastaId,
      },
    );
  }
}
