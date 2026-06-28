import 'dart:async';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _client = ApiClient();
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  Stream<AppUser?> get authStateChanges {
    return Stream.periodic(const Duration(seconds: 1), (_) => _currentUser);
  }

  Future<AppUser> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await _client.post('/auth/register', body: {
      'username': username,
      'email': email,
      'password': password,
    });

    await _client.saveToken(res['token'] as String);
    _currentUser = AppUser.fromJson(res);
    return _currentUser!;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _client.post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    await _client.saveToken(res['token'] as String);
    _currentUser = AppUser.fromJson(res);
    return _currentUser!;
  }

  Future<void> signOut() async {
    await _client.deleteToken();
    _currentUser = null;
  }

  Future<AppUser?> tryAutoLogin() async {
    final hasToken = await _client.hasToken();
    if (!hasToken) return null;

    try {
      final res = await _client.get('/users/me');
      _currentUser = AppUser.fromJson(res);
      return _currentUser;
    } catch (_) {
      await _client.deleteToken();
      return null;
    }
  }
}
