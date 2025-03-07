import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;

class RSAService {
  static const String backendKeyUrl =
      'https://carros-electricos.azurewebsites.net/auth/public-key';

  Future<RSAPublicKey?> fetchPublicKey() async {
    try {
      final response = await http.get(Uri.parse(backendKeyUrl));

      if (response.statusCode == 200) {
        final publicKeyBase64 = response.body;
        return parsePublicKey(formatPublicKey(publicKeyBase64));
      } else {
        print("Error al obtener la clave pública: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  String formatPublicKey(String publicKeyBase64) {
    final cleanBase64 = publicKeyBase64.replaceAll(RegExp(r'\s+'), '');
    final formattedKey = RegExp('.{1,64}')
        .allMatches(cleanBase64)
        .map((m) => m.group(0))
        .join('\n');

    return '''-----BEGIN PUBLIC KEY-----
$formattedKey
-----END PUBLIC KEY-----''';
  }

  RSAPublicKey parsePublicKey(String pem) {
    final parser = RSAKeyParser();
    return parser.parse(pem) as RSAPublicKey;
  }

  Future<String?> encryptMessage(dynamic data) async {
    final publicKey = await fetchPublicKey();
    if (publicKey == null) return null;

    try {
      final encrypter = Encrypter(RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.PKCS1, // ✅ Compatible con el backend
      ));

      final message = jsonEncode(data);
      final encrypted = encrypter.encrypt(message);
      return encrypted.base64;
    } catch (e) {
      return null;
    }
  }
}
