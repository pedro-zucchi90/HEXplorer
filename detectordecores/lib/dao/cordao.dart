import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../database/db.dart';
import '../model/cordetectadamodel.dart';

Future<int> insertCor(CorDetectadaModel cor) async {
  Database db = await getDatabase();
  return await db.insert(
    'cores_detectadas',
    cor.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<CorDetectadaModel>> findAllCores({int limit = 20, int offset = 0}) async {
  try {
    final db = await getDatabase();
    final maps = await db.query(
      'cores_detectadas',
      columns: ['id', 'nome_cor', 'hex_cor', 'imagem_path', 'cores_significativas', 'data_detectada'],
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => CorDetectadaModel.fromMap(map)).toList();
  } catch (e, s) {
    rethrow;
  }
}

Future<CorDetectadaModel?> findCorById(int id) async {
  final db = await getDatabase();
  final maps = await db.query(
    'cores_detectadas',
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );
  if (maps.isNotEmpty) {
    return CorDetectadaModel.fromMap(maps.first);
  }
  return null;
}

Future<int> removeCor(int id) async {
  final db = await getDatabase();
  return db.delete(
    'cores_detectadas',
    where: 'id = ?',
    whereArgs: [id],
  );
} 