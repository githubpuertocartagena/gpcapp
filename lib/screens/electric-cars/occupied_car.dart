import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/assign_form.dart';

class OccupiedCarScreen extends StatelessWidget {
  const OccupiedCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fondo oscuro para diseño moderno
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car_filled,
              size: 100, color: Colors.white), // Ícono de carro
          const SizedBox(height: 20),
          const Text(
            "El carro escaneado está tomado por otra persona.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "¿Desea tomarlo?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 40),

          // ✅ Botón Aceptar
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectricFormScreen()),
              );
            },
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text("Sí, tomarlo"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),

         
          ElevatedButton.icon(
            onPressed: () {
            
              Navigator.pop(
                  context, false); 
            },
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text("No, cancelar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
