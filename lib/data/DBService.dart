
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  // Singleton
  static final DatabaseService _service = DatabaseService._();

  // Constructors
  DatabaseService._(); // Private
  factory DatabaseService() => _service; // Factory

  // -- Database --
  final String DBNAME = 'pflanzen';
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
        'CREATE TABLE pflanzen(id INTEGER PRIMARY KEY, name TEXT, standort TEXT, giessintervall INTEGER, zuletztGegossenDatum TEXT, imageUri TEXT)'
    );
  }

}