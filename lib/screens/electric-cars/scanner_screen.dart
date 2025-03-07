import 'package:flutter/material.dart';
import 'package:gpcapp/hooks/electric-cars/scanner_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ScannerScreen extends ConsumerWidget {
  
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(scannerProvider);

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String qrValue = barcodes.first.rawValue ?? "";
                ref.read(scannerProvider.notifier).handleScan(qrValue, (route) {
                  Navigator.pushReplacementNamed(context, route);
                });
              }
            },
          ),
          Positioned(
            top: 100,
            left: 50,
            right: 50,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Escanea código QR de carro o estación de carga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (errorMessage != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, size: 40, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/scan");
              },
            ),
          ),
        ],
      ),
    );
  }
}
