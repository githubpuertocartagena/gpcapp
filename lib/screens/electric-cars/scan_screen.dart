import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/scanner_screen.dart';
import 'package:gpcapp/widgets/app_bar.dart';

class ScanScreen extends StatelessWidget{
  const ScanScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: "Escáner QR"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            Icon(Icons.qr_code, size: 200),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerScreen()),
                );
              },
              child: Text('Escanear Código QR'),
            ),
          ],
        ),
      ),
    );
  }

}