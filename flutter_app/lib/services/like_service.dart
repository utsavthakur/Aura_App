import '../models/user_model.dart';
import 'api_client.dart';

class LikeService {
  static final LikeService _instance = LikeService._internal();
  factory LikeService() => _instance;
  LikeService._internal();

  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> toggleLike(String postId) async {
    return await _client.post('/posts/$postId/likes');
  }

  Future<List<AppUser>> getPostLikes(String postId) async {
    final res = await _client.get('/posts/$postId/likes');
    final list = res['content'] as List? ?? [];
    return list.map((json) => AppUser.fromJson(json as Map<String, dynamic>)).toList();
  }
}
