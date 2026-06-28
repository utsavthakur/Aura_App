import '../models/post_model.dart';
import 'api_client.dart';

class ExploreService {
  static final ExploreService _instance = ExploreService._internal();
  factory ExploreService() => _instance;
  ExploreService._internal();

  final ApiClient _client = ApiClient();

  Future<List<Post>> getExploreFeed({int page = 0, int size = 20}) async {
    final res = await _client.get('/explore', params: {
      'page': page.toString(),
      'size': size.toString(),
    });
    return _parsePosts(res);
  }

  Future<List<Post>> search(String query, {int page = 0, int size = 20}) async {
    final res = await _client.get('/explore/search', params: {
      'q': query,
      'page': page.toString(),
      'size': size.toString(),
    });
    return _parsePosts(res);
  }

  List<Post> _parsePosts(Map<String, dynamic> res) {
    final list = res['content'] as List? ?? [];
    return list.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }
}
