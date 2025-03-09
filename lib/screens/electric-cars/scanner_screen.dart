import 'dart:io';
import 'package:flutter/material.dart';
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

  void _handleScan(String qrValue) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString("qr1", qrValue);
      final username = prefs.getString("username") ?? "guest";
      final response = await ApiService.fetchRequest("status/$qrValue/$username","GET");
      if (response == null) {
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

      if (status=="occupied") {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OccupiedCarScreen()),
        );
      }
    } catch (e) {
     print(e);
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
          ? Center(child: Text("La cámara no está disponible en el simulador"))
          : Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String qrValue = barcode.rawValue ?? "Código no válido";
                      print("📸 Código QR detectado: $qrValue"); // Imprime en consola
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
