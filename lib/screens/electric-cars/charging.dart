import 'package:flutter/material.dart';

class ChargingCarScreen extends StatelessWidget {
  const ChargingCarScreen({super.key});

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
              // 🔌 Ícono animado de carga de un carro eléctrico
              const Icon(Icons.ev_station, size: 100, color: Colors.greenAccent),
              const SizedBox(height: 20),

              // 📌 Mensaje informativo
              const Text(
                "El carro está cargando...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),

              const Text(
                "Por favor, desconectar la carga antes de continuar con el carro.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              // 🔙 Botón para volver
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Volver"),
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
