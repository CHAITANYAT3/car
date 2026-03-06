import 'package:flutter/foundation.dart';

import '../../core/utils/service_catalog.dart';
import '../../data/models/db_models.dart';
import '../../data/repositories/app_repository.dart';
import '../../domain/entities/app_models.dart';

class AppProvider extends ChangeNotifier {
  AppProvider(this._repository);

  final AppRepository _repository;

  List<Car> newCars = [];
  List<Car> usedCars = [];
  List<Car> pendingUsedCars = [];
  List<SparePart> spareParts = [];
  List<Booking> bookings = [];
  List<SaleTransaction> sales = [];

  Future<void> initialize() async {
    await _repository.seedData();
    await refreshAll();
  }

  Future<void> refreshAll() async {
    newCars = await _repository.getCars(condition: CarCondition.newCar);
    usedCars = await _repository.getCars(condition: CarCondition.usedCar);
    pendingUsedCars = await _repository.getCars(
      condition: CarCondition.usedCar,
      approvedOnly: false,
    );
    pendingUsedCars = pendingUsedCars.where((c) => !c.approved).toList();
    spareParts = await _repository.getSpareParts();
    bookings = await _repository.getBookings();
    sales = await _repository.getSales();
    notifyListeners();
  }

  Future<void> addNewCar({
    required String brand,
    required String model,
    required double price,
    required String description,
  }) async {
    await _repository.addCar(
      CarModel(
        id: _repository.newId(),
        brand: brand,
        model: model,
        price: price,
        description: description,
        condition: CarCondition.newCar,
      ),
    );
    await refreshAll();
  }

  Future<void> submitUsedCarRequest({
    required String seller,
    required String brand,
    required String model,
    required double price,
  }) async {
    await _repository.submitUsedCarRequest(
      seller: seller,
      brand: brand,
      model: model,
      price: price,
    );
    await refreshAll();
  }

  Future<void> approveUsedCar(String carId) async {
    await _repository.approveUsedCar(carId);
    await refreshAll();
  }

  Future<void> bookTestDrive({
    required String userId,
    required String carId,
    required DateTime time,
  }) async {
    await _repository.addBooking(
      BookingModel(
        id: _repository.newId(),
        userId: userId,
        itemId: carId,
        type: 'Test Drive',
        schedule: time,
      ),
    );
    await refreshAll();
  }

  Future<void> bookService({
    required String userId,
    required String carLabel,
    required ServiceTier tier,
    required DateTime time,
  }) async {
    await _repository.addBooking(
      BookingModel(
        id: _repository.newId(),
        userId: userId,
        itemId: '$carLabel (${tier.name})',
        type: 'Service',
        schedule: time,
      ),
    );
    await refreshAll();
  }

  Future<void> purchaseCar({
    required String customerName,
    required Car car,
  }) async {
    await _repository.recordSale(
      SaleModel(
        id: _repository.newId(),
        customerName: customerName,
        carDetails: '${car.brand} ${car.model}',
        amount: car.price,
        date: DateTime.now(),
      ),
    );
    await refreshAll();
  }

  Future<void> buyPart(String id) async {
    await _repository.buySparePart(id);
    await refreshAll();
  }

  List<SparePart> get lowStock => spareParts.where((p) => p.stock < 5).toList();

  List<ServicePackage> get servicePackages => serviceCatalog;
}
