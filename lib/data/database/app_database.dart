import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();
  AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'car_showroom.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            role TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE cars(
            id TEXT PRIMARY KEY,
            brand TEXT,
            model TEXT,
            price REAL,
            condition TEXT,
            description TEXT,
            approved INTEGER,
            sellerName TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE spare_parts(
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            stock INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE bookings(
            id TEXT PRIMARY KEY,
            userId TEXT,
            itemId TEXT,
            type TEXT,
            schedule TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE sales(
            id TEXT PRIMARY KEY,
            customerName TEXT,
            carDetails TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
    return _db!;
  }
}
