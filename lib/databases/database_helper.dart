// lib/databases/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/hike.dart';
import '../models/observation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'hike_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE hikes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            location TEXT NOT NULL,
            date TEXT NOT NULL,
            parkingAvailable TEXT NOT NULL,
            length TEXT NOT NULL,
            difficulty TEXT NOT NULL,
            description TEXT,
            weatherForecast TEXT,
            estimatedDuration TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE observations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            hikeId INTEGER NOT NULL,
            observation TEXT NOT NULL,
            timeOfObservation TEXT NOT NULL,
            additionalComments TEXT,
            FOREIGN KEY (hikeId) REFERENCES hikes (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Hike Methods
  Future<int> insertHike(Hike hike) async {
    final db = await database;
    return await db.insert('hikes', hike.toMap());
  }

  Future<List<Hike>> getHikes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hikes');
    return List.generate(maps.length, (i) => Hike.fromMap(maps[i]));
  }

  Future<int> updateHike(Hike hike) async {
    final db = await database;
    return await db.update(
      'hikes',
      hike.toMap(),
      where: 'id = ?',
      whereArgs: [hike.id],
    );
  }

  Future<int> deleteHike(int id) async {
    final db = await database;
    return await db.delete(
      'hikes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllHikes() async {
    final db = await database;
    return await db.delete('hikes');
  }

  // Observation Methods
  Future<int> insertObservation(Observation observation) async {
    final db = await database;
    return await db.insert('observations', observation.toMap());
  }

  Future<List<Observation>> getObservations(int hikeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'observations',
      where: 'hikeId = ?',
      whereArgs: [hikeId],
    );
    return List.generate(maps.length, (i) => Observation.fromMap(maps[i]));
  }

  Future<int> updateObservation(Observation observation) async {
    final db = await database;
    return await db.update(
      'observations',
      observation.toMap(),
      where: 'id = ?',
      whereArgs: [observation.id],
    );
  }

  Future<int> deleteObservation(int id) async {
    final db = await database;
    return await db.delete(
      'observations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllObservations() async {
    final db = await database;
    return await db.delete('observations');
  }
}
