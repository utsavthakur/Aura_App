import 'user_model.dart';

class Message {
  final String? id;
  final AppUser? sender;
  final AppUser? receiver;
  final String? content;
  final bool isRead;
  final DateTime? createdAt;

  Message({this.id, this.sender, this.receiver, this.content, this.isRead = false, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id']?.toString(),
    sender: json['sender'] != null ? AppUser.fromJson(json['sender']) : null,
    receiver: json['receiver'] != null ? AppUser.fromJson(json['receiver']) : null,
    content: json['content'],
    isRead: json['isRead'] ?? json['read'] ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}
