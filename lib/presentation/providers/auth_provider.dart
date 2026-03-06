import 'package:flutter/foundation.dart';

import '../../data/repositories/app_repository.dart';
import '../../domain/entities/app_models.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AppRepository _repository;
  AppUser? currentUser;
  String? error;

  Future<bool> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    error = null;
    currentUser = await _repository.login(email, password, role);
    if (currentUser == null) {
      error = 'Invalid credentials or role mismatch.';
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _repository.registerCustomer(name, email, password);
      return await login(email: email, password: password, role: UserRole.customer);
    } catch (_) {
      error = 'Could not register user. Email may already exist.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
