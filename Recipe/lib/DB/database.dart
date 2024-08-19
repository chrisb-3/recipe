import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const String dbName = 'shopping_list.db';

  // Open the database
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDatabase(
      dbName,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }

  // Create the database tables
  static void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_items (
        id INTEGER PRIMARY KEY,
        name TEXT,
        checked INTEGER
      )
    ''');
  }
}
