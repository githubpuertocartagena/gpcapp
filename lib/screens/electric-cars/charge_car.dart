import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/charge_scanner.dart';

class ChargeCarScreen extends StatelessWidget {
  const ChargeCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔌 Ícono animado de carga de un carro eléctrico
              const Icon(Icons.ev_station, size: 100, color: Colors.greenAccent),
              const SizedBox(height: 20),

              // 📌 Mensaje informativo
              const Text(
                "Debe seleccionar el carro a cargar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),

              const Text(
                "Seleccione carro a cargar",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              // 🔙 Botón para volver
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChargeScannerScreen()));
                  },
                  label: const Text("Escanear"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
