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
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE cores_detectadas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_cor TEXT NOT NULL,
            hex_cor TEXT NOT NULL,
            imagem_base64 TEXT NOT NULL,
            cores_significativas TEXT,
            data_detectada TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS cores_detectadas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome_cor TEXT NOT NULL,
              hex_cor TEXT NOT NULL,
              imagem_base64 TEXT NOT NULL,
              cores_significativas TEXT,
              data_detectada TEXT
            )
          ''');
        }
      },
    );
  } catch (e, s) {
    rethrow;
  }
}