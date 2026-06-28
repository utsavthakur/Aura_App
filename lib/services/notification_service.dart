import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiClient _client = ApiClient();

  Future<List<AppNotification>> getNotifications() async {
    final res = await _client.get('/notifications');
    return _parseNotifications(res);
  }

  Future<void> markAsRead(String id) async {
    await _client.put('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _client.put('/notifications/read-all');
  }

  Future<int> getUnreadCount() async {
    final res = await _client.get('/notifications/unread');
    return (res['content'] as num?)?.toInt() ?? 0;
  }

  List<AppNotification> _parseNotifications(Map<String, dynamic> res) {
    final list = res['content'] as List? ?? [];
    return list.map((json) => AppNotification.fromJson(json as Map<String, dynamic>)).toList();
  }
}
