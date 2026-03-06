enum UserRole { admin, customer }

enum CarCondition { newCar, usedCar }

enum PaymentMethod { upi, card, netBanking, cash }

enum ServiceTier { basic, standard, premium }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

class Car {
  final String id;
  final String brand;
  final String model;
  final double price;
  final CarCondition condition;
  final String description;
  final bool approved;
  final String? sellerName;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.condition,
    required this.description,
    this.approved = true,
    this.sellerName,
  });
}

class SparePart {
  final String id;
  final String name;
  final double price;
  final int stock;

  const SparePart({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });
}

class ServicePackage {
  final ServiceTier tier;
  final String description;
  final double price;
  final int durationHours;

  const ServicePackage({
    required this.tier,
    required this.description,
    required this.price,
    required this.durationHours,
  });
}

class Booking {
  final String id;
  final String userId;
  final String itemId;
  final String type;
  final DateTime schedule;

  const Booking({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.type,
    required this.schedule,
  });
}

class SaleTransaction {
  final String id;
  final String customerName;
  final String carDetails;
  final double amount;
  final DateTime date;

  const SaleTransaction({
    required this.id,
    required this.customerName,
    required this.carDetails,
    required this.amount,
    required this.date,
  });
}
