import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bulk_order_frontend/core/constants/string_constants.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client, this.tokenProvider})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final Future<String?> Function()? tokenProvider;

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send(StringConstants.get, path, query: query);
  Future<dynamic> post(String path, {Object? body}) =>
      _send(StringConstants.post, path, body: body);
  Future<dynamic> patch(String path, {Object? body}) =>
      _send(StringConstants.patch, path, body: body);
  Future<dynamic> put(String path, {Object? body}) =>
      _send(StringConstants.put, path, body: body);
  Future<dynamic> delete(String path) => _send(StringConstants.delete, path);

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).resolve(path).replace(queryParameters: query);
    final token = await tokenProvider?.call();
    final headers = <String, String>{
      StringConstants.accept: StringConstants.json,
      if (body != null) StringConstants.contentType: StringConstants.json,
      if (token != null && token.isNotEmpty)
        StringConstants.authorization: '${StringConstants.bearerPrefix}$token',
    };
    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final response = await http.Response.fromStream(
        await _client.send(request),
      );
      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded is Map && decoded['detail'] != null
            ? decoded['detail'].toString()
            : '${StringConstants.genericRequestFailed} (${response.statusCode})';
        throw ApiException(message, statusCode: response.statusCode);
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on FormatException {
      throw const ApiException(StringConstants.invalidResponse);
    } on Exception {
      throw const ApiException(StringConstants.connectionFailed);
    }
  }

  void dispose() => _client.close();
}
