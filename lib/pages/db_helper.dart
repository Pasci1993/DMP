import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'redacteur.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'magazine.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE redacteurs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Redacteur r) async =>
      (await database).insert('redacteurs', r.toMap());
  Future<List<Redacteur>> getAll() async {
    final maps = await (await database).query('redacteurs');
    return maps.map((m) => Redacteur.fromMap(m)).toList();
  }

  Future<int> update(Redacteur r) async => (await database).update(
    'redacteurs',
    r.toMap(),
    where: 'id = ?',
    whereArgs: [r.id],
  );
  Future<int> delete(int id) async =>
      (await database).delete('redacteurs', where: 'id = ?', whereArgs: [id]);
}
