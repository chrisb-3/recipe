import 'package:learn/Classes/DayRecipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:learn/Classes/User.dart';


class DatabaseManager {
  static const int _version = 1;
  static const String _databaseName = "recipe.db";

  /** opens (or creates) the databases */
  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _databaseName),
        //open database file. If the database file does not exist, it creates it.
        onCreate: (db, version) async {
          await db.execute("""
        CREATE table users(
          id_user INTEGER NOT NULL PRIMARY KEY,
          email_address TEXT NOT NULL UNIQUE,
          name TEXT
          )
      """);

          await db.execute("""
        CREATE table week(
        id_week INTEGER NOT NULL PRIMARY KEY,
        monday_recipe INTEGER,
        tuesday_recipe INTEGER,
        wednesday_recipe INTEGER,
        thursday_recipe INTEGER,
        friday_recipe INTEGER,
        saturday_recipe INTEGER,
        sunday_recipe INTEGER,
        FOREIGN KEY (monday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (tuesday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (wednesday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (thursday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (friday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (saturday_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (sunday_recipe) REFERENCES recipes(id_recipe)
        )
      """);

          await db.execute("""
        CREATE table recipes(
        id_recipe INTEGER NOT NULL PRIMARY KEY,
        title TEXT,
        imgURL TEXT,
        prepare_time INTEGER,
        cook_time INTEGER
          )
      """);

          await db.execute("""
        CREATE table ingredients(
        id_ingredient INTEGER NOT NULL PRIMARY KEY,
        name TEXT,
        category TEXT,
        kcal INTEGER
          )
      """);

          await db.execute("""
        CREATE table amounts(
        id_recipe INTEGER,
        id_ingredient INTEGER,
        amount INTEGER,
        unit TEXT,
        PRIMARY KEY (id_recipe, id_ingredient),
        FOREIGN KEY (id_recipe) REFERENCES recipes(id_recipe),
        FOREIGN KEY (id_ingredient) REFERENCES ingredients(id_ingredient)
          )
      """);

          await db.execute("""
        CREATE table steps(
        id_recipe INTEGER,
        id_step INTEGER,
        step_number INTEGER,
        instruction TEXT,
        PRIMARY KEY (id_recipe, id_step),
        FOREIGN KEY (id_recipe) REFERENCES recipes(id_recipe)
          )
      """);
        }, version: _version);
  }

  /** create or add user **/
  static Future<int> addUser(User user) async {
    final db = await _getDB();

    try {
      return await db.insert(
          'users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    }
    catch (e) {
      print('Error adding user. + $e');
      return -1;
    }
  }

  /** get a User */
  static Future<User?> getUser(int id) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id_user = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      print('User not found');
      return null;
    }
  }

  /** update User */
  static Future<int> updateUser(User user) async {
    final db = await _getDB();

    return await db.update(
      'users',
      user.toJson(),
      where: 'id_user = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /** delete User */
  static Future<int> deleteUser(User user) async {
    final db = await _getDB();

    return await db.delete(
      'users',
      where: 'id_recipe = ?',
      whereArgs: [user.id],
    );
  }


  /** create or add Recipe **/
  static Future<int> addRecipe(DayRecipe recipe) async {
    final db = await _getDB();

    try {
      return await db.insert('recipes', recipe.toJson(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    }
    catch (e) {
      print('Error adding user. + $e');
      return -1;
    }
  }

  /** get a Recipe */
  static Future<DayRecipe?> getRecipe(int id) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'id_recipe = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DayRecipe.fromJson(maps.first);
    } else {
      print('Recipe not found');
      return null;
    }
  }

  /** update Recipe */
  static Future<int> updateRecipe(DayRecipe recipe) async {
    final db = await _getDB();

    return await db.update(
      'recipes',
      recipe.toJson(),
      where: 'id_recipe = ?',
      whereArgs: [recipe.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /** delete Recipe */
  static Future<int> deleteRecipe(DayRecipe recipe) async {
    final db = await _getDB();

    return await db.delete(
      'recipes',
      where: 'id_recipe = ?',
      whereArgs: [recipe.id],
    );
  }



  static void deleteRecipeDatabase() async{
    final String path = join(await getDatabasesPath(), 'recipe.db');

    // Delete the database
    await deleteDatabase(path);
  }

}