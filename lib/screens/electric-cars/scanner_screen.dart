import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/confirm_car.dart';
import 'package:gpcapp/screens/electric-cars/leave_car.dart';
import 'package:gpcapp/screens/electric-cars/occupied_car.dart';
import 'package:gpcapp/services/api_services.dart';
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
      print("🔍 Estado del QR: $status");

      if (status == "take") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmCarScreen()));
      } else if (status == "occupied") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OccupiedCarScreen()));
      } else if (status == "return") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveCarScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Código QR no reconocido")),
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
      appBar: AppBar(title: const Text("Escáner QR")),
      body: Platform.isIOS && Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')
          ? const Center(child: Text("📵 La cámara no está disponible en el simulador"))
          : Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String qrValue = barcode.rawValue ?? "Código no válido";
                      print("📸 Código QR detectado: $qrValue");
                      _handleScan(qrValue);
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        scannerController.stop();
                        Navigator.pop(context);
                      },
                      child: const Text("Cerrar escáner QR"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        _handleScan("CE-CTC04-C523J");
                      },
                      child: const Text("Simular QR"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
