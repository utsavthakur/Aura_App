import 'user_model.dart';

class AppNotification {
  final String? id;
  final String? type;
  final AppUser? actor;
  final String? referenceId;
  final String? message;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification({this.id, this.type, this.actor, this.referenceId, this.message, this.isRead = false, this.createdAt});

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id']?.toString(),
    type: json['type'],
    actor: json['actor'] != null ? AppUser.fromJson(json['actor']) : null,
    referenceId: json['referenceId']?.toString(),
    message: json['message'],
    isRead: json['isRead'] ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}
