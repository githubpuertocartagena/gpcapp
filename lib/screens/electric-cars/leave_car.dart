import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/assign_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveCarScreen extends StatelessWidget {
  const LeaveCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fondo oscuro
      body: Center( // Centra todo el contenido en la pantalla
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Espaciado lateral
          child: Column(
            mainAxisSize: MainAxisSize.min, // Asegura que solo ocupe el espacio necesario
            children: [
              const Icon(Icons.directions_car_filled, size: 100, color: Colors.white), // Ícono
              const SizedBox(height: 20),
              const Text(
                "Desea entregar el carro.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text(
                "¿Desea entregarlo?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              // ✅ Botón Aceptar
              SizedBox(
                width: double.infinity, // Hace que el botón ocupe todo el ancho posible
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final username = prefs.getString("username") ?? "test";
                    final carCode = prefs.getString("qr1") ?? "testrrrrr";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectricFormScreen(
                          tipo: "ENTREGA",
                          action: "return-car/$carCode",
                          reassign: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Sí, entregarlo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
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
