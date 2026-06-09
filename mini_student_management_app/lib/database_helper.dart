import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      'students.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          admissionNumber TEXT,
          course TEXT
        )
        ''');
      },
    );
  }

  Future<int> insertStudent(
    String name,
    String admissionNumber,
    String course,
  ) async {
    final db = await database;
    return await db.insert(
      'students',
      {
        'name': name,
        'admissionNumber': admissionNumber,
        'course': course,
      },
    );
  }
  Future<List<Map<String, dynamic>>> getStudents() async {

    final db = await database;

    return await db.query('students');
  }
}
