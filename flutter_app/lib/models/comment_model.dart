import 'user_model.dart';

class Comment {
  final String? id;
  final AppUser? user;
  final String? postId;
  final String? content;
  final DateTime? createdAt;

  Comment({this.id, this.user, this.postId, this.content, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id']?.toString(),
    user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
    postId: json['postId']?.toString(),
    content: json['content'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}
