import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final scannerProvider = StateNotifierProvider<ScannerNotifier, String?>((ref) {
  return ScannerNotifier();
});

class ScannerNotifier extends StateNotifier<String?> {
  ScannerNotifier() : super(null);

  Future<void> handleScan(String qrValue, Function(String) navigate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("qr1", qrValue);
      final username = prefs.getString("username") ?? "guest";

      final response = await ApiService.fetchRequest("status/$qrValue/$username","GET");
      if (response == null) {
        state = "Error al leer el código QR";
        return;
      }

      final status = response.body.trim();
      const routeMap = {
        "take": "/confirm-car",
        "occupied": "/occupied-car",
        "return": "/leave-car",
        "charging": "/charging",
        "scan car": "/charge-scanner",
      };

      if (routeMap.containsKey(status)) {
        navigate(routeMap[status]!);
      } else {
        state = "Código QR no reconocido";
      }
    } catch (e) {
      state = "Error al procesar el escaneo: $e";
    }
  }
}
