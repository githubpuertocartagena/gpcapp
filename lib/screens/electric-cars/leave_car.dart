import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/assign_form.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveCarScreen extends StatefulWidget {
  const LeaveCarScreen({super.key});

  @override
  _LeaveCarScreenState createState() => _LeaveCarScreenState();
}

class _LeaveCarScreenState extends State<LeaveCarScreen> {
  late Future<String> _carPlateFuture;

  @override
  void initState() {
    super.initState();
    _carPlateFuture = _fetchCarPlate();
  }

  Future<String> _fetchCarPlate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final carCode = prefs.getString("qr1") ?? "";
      if (carCode.isEmpty) return "Placa no encontrada";

      final response = await ApiService.fetchRequest("placa/$carCode", "GET");

      if (response == null || response.statusCode != 200) {
        return "Placa no disponible";
      }
      
      return response.body.trim();
    } catch (e) {
      return "Error al obtener la placa";
    }
  }

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
              const Icon(Icons.directions_car_filled, size: 100, color: Colors.white),
              const SizedBox(height: 20),

              const Text(
                "Desea entregar el carro.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              // 🔹 Muestra la placa del camión
              FutureBuilder<String>(
                future: _carPlateFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.blue);
                  } else if (snapshot.hasError) {
                    return const Text(
                      "Error al obtener la placa",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    );
                  }
                  return Text(
                    "Placa: ${snapshot.data}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
                  );
                },
              ),
              const SizedBox(height: 15),

              const Text(
                "¿Desea entregarlo?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final username = prefs.getString("username") ?? "";
                    final carCode = prefs.getString("qr1") ?? "";
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
