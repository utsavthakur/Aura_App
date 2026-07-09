import '../models/post_model.dart';
import 'api_client.dart';

class PostService {
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  final ApiClient _client = ApiClient();

  Future<List<Post>> fetchPosts({int page = 0, int size = 10}) async {
    final res = await _client.get('/posts', params: {
      'page': page.toString(),
      'size': size.toString(),
    });

    final list = res['content'] as List? ?? [];
    return list.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Post> createPost({required String content, String? imageUrl}) async {
    final res = await _client.post('/posts', body: {
      'caption': content,
      'mediaUrl': imageUrl,
      'mediaType': imageUrl != null ? 'image' : null,
    });
    return Post.fromJson(res);
  }

  Future<void> deletePost(String id) async {
    await _client.delete('/posts/$id');
  }

  Future<Post> getPost(String id) async {
    final res = await _client.get('/posts/$id');
    return Post.fromJson(res);
  }

  Future<List<Post>> getUserPosts(String userId, {int page = 0, int size = 10}) async {
    final res = await _client.get('/posts/user/$userId', params: {
      'page': page.toString(),
      'size': size.toString(),
    });

    final list = res['content'] as List? ?? [];
    return list.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }
}
