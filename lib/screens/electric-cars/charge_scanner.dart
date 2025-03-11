import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/confirm_charge_car.dart';
import 'package:gpcapp/screens/electric-cars/stop_charging.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:gpcapp/widgets/app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChargeScannerScreen extends StatefulWidget {
  const ChargeScannerScreen({super.key});

  @override
  _ChargeScannerScreenState createState() => _ChargeScannerScreenState();
}

class _ChargeScannerScreenState extends State<ChargeScannerScreen> {
  late MobileScannerController scannerController;
  bool _isProcessing = false; // 🔹 Para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    if (!Platform.isIOS || !Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')) {
      scannerController = MobileScannerController(facing: CameraFacing.back);
    }
  }

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
    if (_isProcessing) return; // Evita múltiples escaneos simultáneos
    setState(() => _isProcessing = true);

    try {
      scannerController.stop(); // 🔹 Detener el escáner para evitar múltiples lecturas
      _showLoadingDialog();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("qr2", qrValue);
      final response = await ApiService.fetchRequest("charge-status/$qrValue", "GET");

      _hideLoadingDialog();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error: No se pudo conectar con el servidor")),
        );
        scannerController.start(); // Reiniciar el escáner
        setState(() => _isProcessing = false);
        return;
      }

      final status = response.body.trim();
      if (status == "charge") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConfirmChargeCarScreen()),
        );
      } else if (status == "stopCharge") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StopChargingScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Código QR no reconocido")),
        );
        scannerController.start(); 
      }
    } catch (e) {
      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al procesar el código QR")),
      );
      scannerController.start(); 
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Escáner QR para cargar carro"),
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
                     
                      ElevatedButton.icon(
                        onPressed: () {
                          scannerController.stop();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel, size: 24, color: Colors.white),
                        label: const Text("Cerrar escáner", style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
