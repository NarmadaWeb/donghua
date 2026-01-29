import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<bool> login(String email, String password) async {
    final List<dynamic> usersJson = await _storageService.readData('users.json');
    final users = usersJson.map((json) => User.fromJson(json)).toList();

    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final List<dynamic> usersJson = await _storageService.readData('users.json');
    final users = usersJson.map((json) => User.fromJson(json)).toList();

    // Check if email already exists
    if (users.any((u) => u.email == email)) {
      return false;
    }

    final newUser = User(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password,
      role: 'user', // Default role for registration is 'user'
    );

    users.add(newUser);
    await _storageService.writeData('users.json', users.map((u) => u.toJson()).toList());

    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
