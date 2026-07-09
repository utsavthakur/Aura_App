import '../models/user_model.dart';
import 'api_client.dart';

class FollowService {
  static final FollowService _instance = FollowService._internal();
  factory FollowService() => _instance;
  FollowService._internal();

  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> toggleFollow(String userId) async {
    return await _client.post('/users/$userId/follow');
  }

  Future<List<AppUser>> getFollowers(String userId) async {
    final res = await _client.get('/users/$userId/follow/followers');
    return _parseUserList(res);
  }

  Future<List<AppUser>> getFollowing(String userId) async {
    final res = await _client.get('/users/$userId/follow/following');
    return _parseUserList(res);
  }

  List<AppUser> _parseUserList(Map<String, dynamic> res) {
    final list = res['content'] as List? ?? [];
    return list.map((json) => AppUser.fromJson(json as Map<String, dynamic>)).toList();
  }
}
