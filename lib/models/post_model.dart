import 'user_model.dart';

class Post {
  final String? id;
  final AppUser? user;
  final String? caption;
  final String? content;
  final String? userId;
  final String? mediaUrl;
  final String? mediaType;
  final String? location;
  final DateTime? createdAt;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;

  Post({
    this.id,
    this.user,
    this.caption,
    this.content,
    this.userId,
    this.mediaUrl,
    this.mediaType,
    this.location,
    this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByMe = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString(),
      user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
      caption: json['caption'] ?? json['content'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'] ?? 'image',
      location: json['location'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      likedByMe: json['likedByMe'] ?? false,
    );
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']?.toString(),
      content: map['content'],
      caption: map['content'],
      mediaUrl: map['image_url'] ?? 'https://picsum.photos/400/600',
      userId: map['user_id']?.toString(),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
