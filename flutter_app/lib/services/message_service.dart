import '../models/message_model.dart';
import 'api_client.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;
  MessageService._internal();

  final ApiClient _client = ApiClient();

  Future<List<Message>> getConversation(String userId) async {
    final res = await _client.get('/messages', params: {'userId': userId});
    return _parseMessages(res);
  }

  Future<Message> sendMessage(String receiverId, String content) async {
    final res = await _client.post('/messages', body: {
      'receiverId': receiverId,
      'content': content,
    });
    return Message.fromJson(res);
  }

  Future<void> markAsRead(String messageId) async {
    await _client.put('/messages/$messageId/read');
  }

  Future<int> getUnreadCount() async {
    final res = await _client.get('/messages/unread');
    return (res['content'] as num?)?.toInt() ?? 0;
  }

  List<Message> _parseMessages(Map<String, dynamic> res) {
    final list = res['content'] as List? ?? [];
    return list.map((json) => Message.fromJson(json as Map<String, dynamic>)).toList();
  }
}
