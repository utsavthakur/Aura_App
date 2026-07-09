import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, String>> _headers({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? params}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: params);
    final response = await http
        .get(uri, headers: await _headers())
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await http
        .post(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null)
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await http
        .put(uri, headers: await _headers(), body: body != null ? jsonEncode(body) : null)
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<void> delete(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await http
        .delete(uri, headers: await _headers())
        .timeout(ApiConfig.timeout);
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw HttpException('Request failed: ${response.statusCode} ${response.body}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    String message = 'Request failed';
    try {
      final json = jsonDecode(response.body);
      if (json is Map && json['message'] != null) {
        message = json['message'] as String;
      }
    } catch (_) {
      if (response.body.isNotEmpty) message = response.body;
    }
    throw HttpException('${response.statusCode}: $message');
  }
}
