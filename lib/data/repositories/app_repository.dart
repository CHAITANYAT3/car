import 'package:uuid/uuid.dart';

import '../../domain/entities/app_models.dart';
import '../database/app_database.dart';
import '../models/db_models.dart';

class AppRepository {
  AppRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<void> seedData() async {
    final db = await _database.database;
    final users = await db.query('users');
    if (users.isNotEmpty) return;

    await db.insert(
      'users',
      const UserModel(
        id: 'admin-1',
        name: 'Administrator',
        email: 'admin@showroom.com',
        password: 'admin123',
        role: UserRole.admin,
      ).toMap(),
    );

    await db.insert(
      'users',
      const UserModel(
        id: 'user-1',
        name: 'John Driver',
        email: 'user@showroom.com',
        password: 'user123',
        role: UserRole.customer,
      ).toMap(),
    );

    const parts = [
      ('Brake', 120.0, 12),
      ('Clutch', 280.0, 8),
      ('Air Filter', 45.0, 6),
      ('Horn', 35.0, 15),
      ('Head Light', 90.0, 4),
      ('Tail Light', 70.0, 5),
      ('Repair Kit', 60.0, 10),
      ('Spark Plug', 25.0, 3),
    ];

    for (final p in parts) {
      await db.insert(
        'spare_parts',
        SparePartModel(id: _uuid.v4(), name: p.$1, price: p.$2, stock: p.$3).toMap(),
      );
    }

    await addCar(
      const CarModel(
        id: 'car-1',
        brand: 'Tesla',
        model: 'Model 3',
        price: 45000,
        condition: CarCondition.newCar,
        description: 'Electric sedan with autopilot features',
      ),
    );
    await addCar(
      const CarModel(
        id: 'car-2',
        brand: 'Toyota',
        model: 'Corolla 2020',
        price: 15000,
        condition: CarCondition.usedCar,
        description: 'Well maintained, single owner',
      ),
    );
  }

  Future<AppUser?> login(String email, String password, UserRole role) async {
    final db = await _database.database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ? AND role = ?',
      whereArgs: [email, password, role.name],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<void> registerCustomer(String name, String email, String password) async {
    final db = await _database.database;
    await db.insert(
      'users',
      UserModel(
        id: _uuid.v4(),
        name: name,
        email: email,
        password: password,
        role: UserRole.customer,
      ).toMap(),
    );
  }

  Future<List<Car>> getCars({CarCondition? condition, bool approvedOnly = true}) async {
    final db = await _database.database;
    final clauses = <String>[];
    final args = <Object?>[];
    if (condition != null) {
      clauses.add('condition = ?');
      args.add(condition.name);
    }
    if (approvedOnly) {
      clauses.add('approved = 1');
    }

    final rows = await db.query(
      'cars',
      where: clauses.isEmpty ? null : clauses.join(' AND '),
      whereArgs: args,
    );
    return rows.map(CarModel.fromMap).toList();
  }

  Future<void> addCar(CarModel car) async {
    final db = await _database.database;
    await db.insert('cars', car.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> approveUsedCar(String carId) async {
    final db = await _database.database;
    await db.update('cars', {'approved': 1}, where: 'id = ?', whereArgs: [carId]);
  }

  Future<void> submitUsedCarRequest({
    required String seller,
    required String brand,
    required String model,
    required double price,
  }) async {
    await addCar(
      CarModel(
        id: _uuid.v4(),
        brand: brand,
        model: model,
        price: price,
        condition: CarCondition.usedCar,
        description: 'Seller request submitted',
        approved: false,
        sellerName: seller,
      ),
    );
  }

  Future<List<SparePart>> getSpareParts() async {
    final db = await _database.database;
    final rows = await db.query('spare_parts');
    return rows.map(SparePartModel.fromMap).toList();
  }

  Future<void> buySparePart(String id) async {
    final db = await _database.database;
    final rows = await db.query('spare_parts', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return;
    final item = SparePartModel.fromMap(rows.first);
    final next = item.stock > 0 ? item.stock - 1 : 0;
    await db.update('spare_parts', {'stock': next}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addBooking(BookingModel booking) async {
    final db = await _database.database;
    await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookings() async {
    final db = await _database.database;
    final rows = await db.query('bookings', orderBy: 'schedule DESC');
    return rows.map(BookingModel.fromMap).toList();
  }

  Future<void> recordSale(SaleModel sale) async {
    final db = await _database.database;
    await db.insert('sales', sale.toMap());
  }

  Future<List<SaleTransaction>> getSales() async {
    final db = await _database.database;
    final rows = await db.query('sales', orderBy: 'date DESC');
    return rows.map(SaleModel.fromMap).toList();
  }

  String newId() => _uuid.v4();
}
