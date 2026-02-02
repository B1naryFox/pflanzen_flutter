
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  // Singleton
  static final DatabaseService _dbService = DatabaseService._privateConstructor();

  // Constructors
  DatabaseService._privateConstructor(); // Private Constructor is used to initialize the singleton
  factory DatabaseService() => _dbService; // Factory Constructor returns the instance of the singleton instead of creating a new one

  // -- Database --
  final String DBTABLENAME = 'pflanzen';
  final String DBPATHNAME = 'pflanzen_sqflite.db';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _innitDatabase();
    return _database!;
  }

  Future<Database> _innitDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DBPATHNAME);

    return await openDatabase(
        path,
      onCreate: _onCreate,
      version: 1
        //, onconfigure:
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $DBTABLENAME(id INTEGER PRIMARY KEY, name TEXT, standort TEXT, giessintervall INTEGER, zuletztGegossenDatum TEXT, imageUri TEXT)'
    );
  }
}