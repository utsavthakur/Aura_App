import 'user_model.dart';

class Post {
  final String id;
  final User? user; // Backend sends 'user' object
  final String? caption;
  final String? content; // Added
  final String? userId; // Added
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final DateTime? createdAt;
  final int likeCount;
  final int commentCount;

  Post({
    required this.id,
    this.user,
    this.caption,
    this.content,
    this.userId,
    required this.mediaUrl,
    this.mediaType = 'image',
    this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      caption: json['caption'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'] ?? 'image',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
    );
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'], // Added content mapping
      caption: map['content'], // Map content to caption for UI compatibility
      mediaUrl: map['image_url'] ?? 'https://picsum.photos/400/600',
      userId: map['user_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
