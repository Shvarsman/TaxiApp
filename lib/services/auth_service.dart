import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_app/models/user.dart';

class AuthService {
  final _box = Hive.box('cache');
  static const _sessionKey = 'session';

  Future<AppUser?> tryAutoLogin() async {
    final data = _box.get(_sessionKey);
    if (data != null) {
      return AppUser(email: data['email'], name: data['name']);
    }
    return null;
  }

  Future<AppUser> login(String email, String password) async {
    // имитация проверки
    if (email.isEmpty || password.isEmpty) throw Exception('Invalid credentials');
    await Future.delayed(const Duration(seconds: 1));
    final user = AppUser(email: email, name: email.split('@')[0]);
    await _box.put(_sessionKey, {'email': email, 'name': user.name});
    return user;
  }

  Future<void> logout() async {
    await _box.delete(_sessionKey);
  }
}