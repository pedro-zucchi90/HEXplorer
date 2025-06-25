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

Future<List<CorDetectadaModel>> findAllCores() async {
  try {
    final db = await getDatabase();
    final maps = await db.query(
      'cores_detectadas',
      orderBy: 'id DESC',
    );
    return maps.map((map) => CorDetectadaModel.fromMap(map)).toList();
  } catch (e, s) {
    rethrow;
  }
}

Future<int> removeCor(int id) async {
  final db = await getDatabase();
  return db.delete(
    'cores_detectadas',
    where: 'id = ?',
    whereArgs: [id],
  );
} 