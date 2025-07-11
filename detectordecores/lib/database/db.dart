//Arquivo responsável por criar o banco de dados SQLite para o app de detecção de cores.

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;

Future<Database> getDatabase() async {
  try {
    // Inicializa o databaseFactory para sqflite_common_ffi apenas em desktop
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Em Android/iOS, NÃO inicializa nada de FFI
    String caminhoDatabase = join(await getDatabasesPath(), 'cores_detectadas.db');
    return await openDatabase(
      caminhoDatabase,
      version: 6, // incrementa a versão
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE cores_detectadas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_cor TEXT NOT NULL,
            hex_cor TEXT NOT NULL,
            imagem_path TEXT,
            cores_significativas TEXT,
            data_detectada TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 6) {
          // Cria nova tabela sem imagem_base64
          await db.execute('''
            CREATE TABLE cores_detectadas_nova (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome_cor TEXT NOT NULL,
              hex_cor TEXT NOT NULL,
              imagem_path TEXT,
              cores_significativas TEXT,
              data_detectada TEXT
            )
          ''');
          await db.execute('''
            INSERT INTO cores_detectadas_nova (id, nome_cor, hex_cor, imagem_path, cores_significativas, data_detectada)
            SELECT id, nome_cor, hex_cor, imagem_path, cores_significativas, data_detectada FROM cores_detectadas;
          ''');
          await db.execute('DROP TABLE cores_detectadas;');
          await db.execute('ALTER TABLE cores_detectadas_nova RENAME TO cores_detectadas;');
        }
      },
    );
  } catch (e, s) {
    rethrow;
  }
}