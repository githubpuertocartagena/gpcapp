import 'package:gpcapp/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<http.Response?> fetchRequest(String url, String method, {Map<String, dynamic>? body}) async {
    String? accessToken = await AuthService.getAccessToken();

    var response = await _makeRequest(url, method, accessToken, body);

    if (response?.statusCode == 401) {
      response = await _makeRequest(url, method, accessToken, body);
    }

    return response;
  }

  static Future<http.Response> _makeRequest(String url, String method, String? accessToken, Map<String, dynamic>? body) async {
    Uri uri = Uri.parse("https://carros-electricos.azurewebsites.net/"+url);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw UnsupportedError('Método HTTP no soportado: $method');
    }
  }
}
