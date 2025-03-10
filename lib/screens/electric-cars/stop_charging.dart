import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/scan_screen.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopChargingScreen extends StatefulWidget {
  const StopChargingScreen({super.key});

  @override
  _StopCharginCarScreenState createState() => _StopCharginCarScreenState();
}

class _StopCharginCarScreenState extends State<StopChargingScreen> {
  bool _isLoading = false; // Controla el estado de carga

  // 🔹 Función para mostrar el popup de carga
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // No permitir cerrar el popup manualmente
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Procesando, por favor espere...")
            ],
          ),
        );
      },
    );
  }

  // 🔹 Función para cerrar el popup de carga
  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // 🔹 Función para iniciar la carga
  Future<void> _stopCharging() async {
    setState(() => _isLoading = true);
    _showLoadingDialog(); // Muestra el popup de carga

    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString("username") ?? "";
      final carCode = prefs.getString("qr2") ?? "";

      final response = await ApiService.fetchRequest(
          "remove-station/$carCode/$username", "PUT");

      _hideLoadingDialog(); // Oculta el popup de carga

      if (response == null) {
        throw Exception("No se pudo desasignar carro a estación.");
      }

      // Redirigir a la pantalla de escaneo tras completar la acción
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScanScreen()),
      );
    } catch (e) {
      _hideLoadingDialog();
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No se pudo asignar carro a estación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fondo oscuro para diseño moderno
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.ev_station, size: 100, color: Colors.greenAccent), // Ícono de carga
              const SizedBox(height: 20),

              const Text(
                "El carro va ha dejar de cargarse.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),

              const Text(
                "¿Desea desconectarlo?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _stopCharging, // Evita múltiples clics
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Sí, desconectarlo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading ? Colors.grey : Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ❌ Botón Cancelar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    Navigator.pop(context, false);
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text("No, cancelar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
