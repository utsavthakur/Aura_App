import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aura_app/services/auth_service.dart';
import 'package:aura_app/models/post_model.dart';

class PostService {
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  final _supabase = Supabase.instance.client;

  /// Fetch all posts sorted by newest first
  Future<List<Post>> fetchPosts() async {
    final response = await _supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((map) => Post.fromMap(map)).toList();
  }

  /// Create a new post
  Future<void> createPost({required String content, String? imageUrl}) async {
    final user = AuthService().currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase.from('posts').insert({
      'content': content,
      'image_url': imageUrl,
      'user_id': user.id,
    });
  }
}
