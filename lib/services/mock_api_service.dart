import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/story_model.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  final List<String> _videoUrls = [
    'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-lighting-in-the-rain-39767-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-on-a-young-woman-39837-large.mp4',
  ];

  Future<List<User>> _getRandomUsers(int count) async {
    return List.generate(count, (i) => User(
      id: i, 
      username: 'user$i',
      email: 'user$i@example.com',
      bio: 'A passionate creator sharing my journey.',
      profilePicture: 'https://picsum.photos/id/${i + 20}/200/200.jpg',
    ));
  }

  Future<User?> getUserProfile() async {
    return User(
      id: 1,
      username: 'utsav_thakur',
      email: 'utsav@example.com',
      bio: 'Building the future of social media with AURA. 🚀',
      profilePicture: 'https://picsum.photos/id/64/200/200.jpg',
    );
  }

  Future<List<Post>> getMockPosts() async {
    final users = await _getRandomUsers(10);
    return List.generate(10, (index) {
      final user = users[index % users.length];
      final isVideo = index % 3 == 0; // Every 3rd post is a video
      
      return Post(
        id: index.toString(),
        user: user,
        caption: 'Beautiful day exploring the world! #AURA #Life #Vibes',
        mediaUrl: isVideo 
            ? _videoUrls[index % _videoUrls.length]
            : 'https://picsum.photos/id/${index + 30}/800/1000.jpg',
        mediaType: isVideo ? 'video' : 'image',
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
        likeCount: (index + 1) * 42,
        commentCount: (index + 1) * 7,
      );
    });
  }

  Future<List<Story>> getMockStories() async {
    final users = await _getRandomUsers(15);
    return users.map((user) => Story(
      id: user.id ?? 0,
      user: user,
      mediaUrl: 'https://picsum.photos/id/${user.id ?? 10 + 50}/400/700.jpg',
      mediaType: MediaType.IMAGE,
      createdAt: DateTime.now(),
    )).toList();
  }
}
