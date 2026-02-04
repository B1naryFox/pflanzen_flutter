
import 'package:pflanzen_flutter/data/DBService.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'package:sqflite/sqlite_api.dart';

class PlantRepository {
  DatabaseService db_service = DatabaseService();

  Future<List<Plant>> loadPlants() async {
    final db = await db_service.database;
    final List<Map<String, dynamic>> plantMaps = await db.query(db_service.DBTABLENAME);
    return List.generate(plantMaps.length, (index) => Plant.fromMap(plantMaps[index]));
  }
  
  Future<void> addPlant(Plant plant) async {
     final db = await db_service.database;
     await db.insert(db_service.DBTABLENAME, plant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await db_service.database;
    await db.update(db_service.DBTABLENAME, plant.toMap(), where: 'id =?', whereArgs: [plant.id]);
  }

  Future<void> deletePlant(int id) async {
    final db = await db_service.database;
    await db.delete(
        db_service.DBTABLENAME, where: 'id =?',
        whereArgs: [id]);
  }
}