import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_manager_app/database/event.dart';

const String DB_NAME = "movies_database.db";
const String TABLE_EVENT = "event";

class DatabaseProvider{
  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  Database _database;

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), DB_NAME),
    version: 1,
    onCreate: (db, version){
      db.execute("""CREATE TABLE $TABLE_EVENT (
            id INTEGER PRIMARY KEY,
            title TEXT,
            start INTEGER,
            end INTEGER,
            color INTEGER,
            repeat INTEGER
        )""");

    });
  }

  Future close() {
    return _database?.close();
  }

  Future<int> addEvent(Event event) async {
    final db = await database;
    return await db.insert(TABLE_EVENT, event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(TABLE_EVENT, event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(TABLE_EVENT, orderBy: "start");
    return maps.map((e) => Event.fromJson(e)).toList();
  }

}
