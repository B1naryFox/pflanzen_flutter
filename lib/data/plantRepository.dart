
import 'package:pflanzen_flutter/data/DBService.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'package:sqflite/sqlite_api.dart';

class PlantRepository {
  final DatabaseService dbService;
  // Singleton
  static final PlantRepository _plantRepository = PlantRepository._privateConstructor(DatabaseService());

  // Constructors
  PlantRepository._privateConstructor(this.dbService);
  factory PlantRepository() => _plantRepository;

  // -- CRUD --
  Future<List<Plant>> loadPlants() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> plantMaps = await db.query(dbService.DBTABLENAME);
    return List.generate(plantMaps.length, (index) => Plant.fromMap(plantMaps[index]));
  }
  
  Future<void> addPlant(Plant plant) async {
     final db = await dbService.database;
     await db.insert(dbService.DBTABLENAME, plant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await dbService.database;
    await db.update(dbService.DBTABLENAME, plant.toMap(), where: 'id =?', whereArgs: [plant.id]);
  }

  Future<void> deletePlant(String id) async {
    final db = await dbService.database;
    await db.delete(
        dbService.DBTABLENAME, where: 'id =?',
        whereArgs: [id]);
  }
  void dispose(){

  }
}