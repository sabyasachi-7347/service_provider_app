import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static Uri _uri(String path, [Map<String, String?> query = const {}]) {
    final filteredQuery = <String, String>{};
    query.forEach((key, value) {
      if (value != null && value.trim().isNotEmpty) {
        filteredQuery[key] = value;
      }
    });

    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$baseUrl$normalizedPath',
    ).replace(queryParameters: filteredQuery.isEmpty ? null : filteredQuery);
  }

  static Future<dynamic> _decodeResponse(http.Response response) async {
    final body = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message =
          body is Map<String, dynamic> ? body['message']?.toString() : null;
      throw Exception(message ?? 'Request failed (${response.statusCode})');
    }

    return body;
  }

  static Future<dynamic> _get(
    String path, [
    Map<String, String?> query = const {},
  ]) async {
    final response = await http.get(_uri(path, query));
    return _decodeResponse(response);
  }

  static Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  static Future<dynamic> _patch(String path, Map<String, dynamic> body) async {
    final response = await http.patch(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> login({
    required String userId,
    String? password,
  }) async {
    final data = await _post('auth/login', {
      'userId': userId,
      if (password != null) 'password': password,
    });
    return data as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getConsumers({
    String? city,
    String? sector,
    String? houseType,
    String? building,
    String? query,
  }) async {
    final data = await _get('consumers', {
      'city': city,
      'sector': sector,
      'houseType': houseType,
      'building': building,
      'q': query,
    });
    return data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getConsumer(String id) async {
    final data = await _get('consumers/$id');
    return data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateConsumer(
    String id,
    Map<String, dynamic> body,
  ) async {
    final data = await _patch('consumers/$id', body);
    return data as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getServiceProviders({
    String? city,
    String? category,
    double? minRating,
    String? query,
  }) async {
    final data = await _get('service-providers', {
      'city': city,
      'category': category,
      'minRating': minRating?.toString(),
      'q': query,
    });
    return data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> createServiceProvider(
    Map<String, dynamic> body,
  ) async {
    final data = await _post('service-providers', body);
    return data as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getRequests({
    String? status,
    String? category,
    String? query,
  }) async {
    final data = await _get('requests', {
      'status': status,
      'category': category,
      'q': query,
    });
    return data as List<dynamic>;
  }

  static Future<Map<String, dynamic>> createRequest(
    Map<String, dynamic> body,
  ) async {
    final data = await _post('requests', body);
    return data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getServiceProviderDashboard(
    String providerId,
  ) async {
    final data = await _get('service-providers/$providerId/dashboard');
    return data as Map<String, dynamic>;
  }
}
