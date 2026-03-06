import '../../domain/entities/app_models.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.role,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role.name,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        role: UserRole.values.firstWhere((r) => r.name == map['role']),
      );
}

class CarModel extends Car {
  const CarModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.price,
    required super.condition,
    required super.description,
    super.approved,
    super.sellerName,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'brand': brand,
        'model': model,
        'price': price,
        'condition': condition.name,
        'description': description,
        'approved': approved ? 1 : 0,
        'sellerName': sellerName,
      };

  factory CarModel.fromMap(Map<String, dynamic> map) => CarModel(
        id: map['id'] as String,
        brand: map['brand'] as String,
        model: map['model'] as String,
        price: (map['price'] as num).toDouble(),
        condition: CarCondition.values.firstWhere(
          (c) => c.name == map['condition'],
        ),
        description: map['description'] as String,
        approved: (map['approved'] as int) == 1,
        sellerName: map['sellerName'] as String?,
      );
}

class SparePartModel extends SparePart {
  const SparePartModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
      };

  factory SparePartModel.fromMap(Map<String, dynamic> map) => SparePartModel(
        id: map['id'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        stock: map['stock'] as int,
      );
}

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.itemId,
    required super.type,
    required super.schedule,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'itemId': itemId,
        'type': type,
        'schedule': schedule.toIso8601String(),
      };

  factory BookingModel.fromMap(Map<String, dynamic> map) => BookingModel(
        id: map['id'] as String,
        userId: map['userId'] as String,
        itemId: map['itemId'] as String,
        type: map['type'] as String,
        schedule: DateTime.parse(map['schedule'] as String),
      );
}

class SaleModel extends SaleTransaction {
  const SaleModel({
    required super.id,
    required super.customerName,
    required super.carDetails,
    required super.amount,
    required super.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'customerName': customerName,
        'carDetails': carDetails,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory SaleModel.fromMap(Map<String, dynamic> map) => SaleModel(
        id: map['id'] as String,
        customerName: map['customerName'] as String,
        carDetails: map['carDetails'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
      );
}
