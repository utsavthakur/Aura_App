import '../models/comment_model.dart';
import 'api_client.dart';

class CommentService {
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  final ApiClient _client = ApiClient();

  Future<List<Comment>> getPostComments(String postId) async {
    final res = await _client.get('/posts/$postId/comments');
    final list = _extractList(res);
    return list.map((json) => Comment.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Comment> createComment(String postId, String content) async {
    final res = await _client.post('/posts/$postId/comments', body: {
      'content': content,
    });
    return Comment.fromJson(res);
  }

  Future<void> deleteComment(String commentId) async {
    await _client.delete('/posts/0/comments/$commentId');
  }

  List<dynamic> _extractList(Map<String, dynamic> res) {
    if (res.containsKey('content')) return res['content'] as List? ?? [];
    return res.values.first is List ? res.values.first as List : [];
  }
}
