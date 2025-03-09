import 'package:gpcapp/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarService {
  static const String apiBaseUrl = 'https://carros-electricos.azurewebsites.net';

  static Future<String?> fetchPlaca() async {
    final prefs = await SharedPreferences.getInstance();
    String? qrValue = prefs.getString('qr2') ?? prefs.getString('qr1');

    final response = await ApiService.fetchRequest('$apiBaseUrl/placa/$qrValue', 'GET');

    if (response != null && response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}

