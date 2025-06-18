import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoritePokemonDb {
  static final FavoritePokemonDb _instance = FavoritePokemonDb._internal();
  factory FavoritePokemonDb() => _instance;
  FavoritePokemonDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorite_pokemon.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(int id) async {
    final db = await database;
    await db.insert('favorites', {'id': id},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<int>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((row) => row['id'] as int).toList();
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
} 