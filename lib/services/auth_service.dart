import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveToken(String accessToken) async {
    if (accessToken.isNotEmpty) {
      await _secureStorage.write(key: 'accessToken', value: accessToken);
    }
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  static Future<bool> fetchLogin(String encryptedData) async {
    try {
      final response = await http.post(
        Uri.parse('https://carros-electricos.azurewebsites.net/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: encryptedData,
      );

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> fetchValidateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://carros-electricos.azurewebsites.net/auth/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      final data = jsonDecode(response.body);

      if (data['active'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', data['username']);
        await prefs.setString('name', data['name']);
      }

      return data['active'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'accessToken');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('name');
    await prefs.remove('password');
    await prefs.remove('qr1');
    await prefs.remove('qr2');
  }
}
