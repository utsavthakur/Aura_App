import '../models/story_model.dart';
import 'api_client.dart';

class StoryService {
  static final StoryService _instance = StoryService._internal();
  factory StoryService() => _instance;
  StoryService._internal();

  final ApiClient _client = ApiClient();

  Future<List<Story>> getActiveStories() async {
    final res = await _client.get('/stories');
    final list = res['content'] as List? ?? [];
    return list.map((json) => Story.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Story> createStory(String mediaUrl, String mediaType) async {
    final res = await _client.post('/stories', body: {
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    });
    return Story.fromJson(res);
  }
}
