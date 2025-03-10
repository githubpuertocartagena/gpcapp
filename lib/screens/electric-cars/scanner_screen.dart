import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/charge_car.dart';
import 'package:gpcapp/screens/electric-cars/charging.dart';
import 'package:gpcapp/screens/electric-cars/confirm_car.dart';
import 'package:gpcapp/screens/electric-cars/leave_car.dart';
import 'package:gpcapp/screens/electric-cars/occupied_car.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:gpcapp/widgets/app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late MobileScannerController scannerController;

  // 🔹 Muestra el popup de carga
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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

  // 🔹 Cierra el popup de carga
  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // 🔹 Cierra sesión y redirige a la pantalla de login
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos guardados
    Navigator.pushReplacementNamed(context, "/login"); // Redirige al login
  }

  // 🔹 Maneja el escaneo
  void _handleScan(String qrValue) async {
    try {
      _showLoadingDialog(); // Muestra el popup de carga

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("qr1", qrValue);
      final username = prefs.getString("username") ?? "guest";
      final response = await ApiService.fetchRequest("status/$qrValue/$username", "GET");

      _hideLoadingDialog(); // Oculta el popup de carga

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error: No se pudo conectar con el servidor")),
        );
        return;
      }

      final status = response.body.trim();

      if (status == "take") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmCarScreen()));
      } else if (status == "occupied") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OccupiedCarScreen()));
      } else if (status == "return") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveCarScreen()));
      } else if (status == "Charging") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChargingCarScreen()));
      }  else if (status == "scan car") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChargeCarScreen()));
      }  else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Código QR no reconocido")),
        );
      }
    } catch (e) {
      _hideLoadingDialog(); // Asegurar que el popup se cierre en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al procesar el código QR")),
      );
      print("❌ Error en _handleScan: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (!Platform.isIOS || !Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')) {
      scannerController = MobileScannerController(facing: CameraFacing.back);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Escáner QR"),
      body: Platform.isIOS && Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')
          ? const Center(child: Text("La cámara no está disponible en el simulador"))
          : Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String qrValue = barcode.rawValue ?? "Código no válido";
                      _handleScan(qrValue);
                    }
                  },
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _handleScan("EC-H4F2M-8D722"); // 🔥 Simulación de QR
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("🔄 Simular QR"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          scannerController.stop();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("❌ Cerrar escáner"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
