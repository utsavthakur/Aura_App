import '../models/user_model.dart';
import '../models/post_model.dart';
import 'api_client.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ApiClient _client = ApiClient();

  Future<AppUser> getProfile(String userId) async {
    final res = await _client.get('/users/$userId');
    return AppUser.fromJson(res);
  }

  Future<AppUser> getMe() async {
    final res = await _client.get('/users/me');
    return AppUser.fromJson(res);
  }

  Future<AppUser> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (bio != null) body['bio'] = bio;
    if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

    final res = await _client.put('/users/me', body: body);
    return AppUser.fromJson(res);
  }
}
