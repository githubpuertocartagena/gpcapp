import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;

class RSAService {
  String? errorRSA;

  /// 🔹 Obtiene la clave pública del backend
  Future<String?> fetchPublicKey() async {
    try {
      final response = await http.get(Uri.parse('https://carros-electricos.azurewebsites.net/auth/public-key'));

      if (response.statusCode == 200) {
        return formatPublicKey(response.body);
      } else {
        errorRSA = "Error al obtener la clave pública: ${response.statusCode}";
        return null;
      }
    } catch (e) {
      errorRSA = "Error al obtener la clave pública: $e";
      return null;
    }
  }

  /// 🔹 Encripta un mensaje con RSA
  Future<String?> encryptMessage(dynamic data) async {
    final publicKeyPEM = await fetchPublicKey();

    if (publicKeyPEM == null) {
      return null;
    }

    try {
      final parser = RSAKeyParser();
      final publicKey = parser.parse(publicKeyPEM) as RSAPublicKey;

      final encrypter = Encrypter(RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.PKCS1, // Usa PKCS1Padding, igual que el backend en Spring Boot
      ));

      final message = (data is Map || data is List) ? data.toString() : data.toString();
      final encrypted = encrypter.encrypt(message);

      return encrypted.base64;
    } catch (e) {
      errorRSA = "Error al encriptar el mensaje: $e";
      return null;
    }
  }

  /// 🔹 Convierte una clave pública Base64 en formato PEM
String formatPublicKey(String publicKeyBase64) {
  try {
    final cleanBase64 = publicKeyBase64.replaceAll(RegExp(r'\s+'), ''); // Limpiar espacios
    final formattedKey = RegExp('.{1,64}').allMatches(cleanBase64).map((m) => m.group(0)).join('\n');
    
    return '''-----BEGIN PUBLIC KEY-----
$formattedKey
-----END PUBLIC KEY-----''';
  } catch (e) {
    throw Exception("Error al formatear la clave pública: $e");
  }
}

}
