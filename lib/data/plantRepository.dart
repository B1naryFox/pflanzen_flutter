
import 'package:pflanzen_flutter/data/DBService.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/data/plantService.dart';
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
    return List.generate(plantMaps.length, (index) => PlantService.mapToPlant(plantMaps[index]));
  }
  
  Future<void> addPlant(Plant plant) async {
     final db = await dbService.database;
     await db.insert(dbService.DBTABLENAME, PlantService.plantToMap(plant), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await dbService.database;
    await db.update(dbService.DBTABLENAME, PlantService.plantToMap(plant), where: 'id =?', whereArgs: [plant.id]);
  }

  Future<void> deletePlant(int id) async {
    final db = await dbService.database;
    await db.delete(
        dbService.DBTABLENAME, where: 'id =?',
        whereArgs: [id]);
  }
}