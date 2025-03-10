import 'package:flutter/material.dart';
import 'package:gpcapp/screens/electric-cars/scan_screen.dart';
import 'package:gpcapp/services/api_services.dart';
import 'package:gpcapp/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElectricFormScreen extends StatefulWidget {
  final String tipo;
  final String action;
  final bool reassign;

  const ElectricFormScreen({
    Key? key,
    required this.tipo,
    required this.action,
    this.reassign = false,
  }) : super(key: key);

  @override
  _ElectricFormScreenState createState() => _ElectricFormScreenState();
}

class _ElectricFormScreenState extends State<ElectricFormScreen> {
  final List<Map<String, String>> questions = [
    {"question": "Cinturones", "key": "cinturones"},
    {"question": "Sistemas de luces (delanteras, traseras, estacionarias y estroboscópica)", "key": "luces"},
    {"question": "Banderín", "key": "banderin"},
    {"question": "Limpiabrisas", "key": "limpiabrisas"},
    {"question": "Llantas", "key": "llantas"},
    {"question": "Bocinas", "key": "bocinas"},
    {"question": "Panorámico y Retrovisores", "key": "retrovisores"},
    {"question": "Alarma de Reversa", "key": "alarmaDeReversa"},
    {"question": "Extintor", "key": "extintor"},
    {"question": "Conos", "key": "conos"},
    {"question": "Batería", "key": "bateria"},
  ];

  Map<String, String?> selectedAnswers = {};
  final TextEditingController _observationsController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Formulario "),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['question']!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedAnswers[question['key']] == "Sí" ? Colors.green : Colors.grey,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedAnswers[question['key']!] = "Sí";
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.check, color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text('Sí', style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedAnswers[question['key']] == "No" ? Colors.red : Colors.grey,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedAnswers[question['key']!] = "No";
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.close, color: Colors.white, size: 24),
                                    SizedBox(width: 8),
                                    Text('No', style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Campo de Observaciones Generales
            TextField(
              controller: _observationsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Observaciones Generales",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Botones de Guardar y Cancelar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _saveForm(),
                  icon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.save, color: Colors.white),
                  label: const Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading ? Colors.grey : Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    Navigator.pop(context); // Cierra la pantalla
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text("Cancelar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Muestra el popup de carga
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario lo cierre manualmente
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Enviando formulario, por favor espere...")
            ],
          ),
        );
      },
    );
  }

  // ✅ Cierra el popup de carga
  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ✅ Función para guardar respuestas y observaciones
  void _saveForm() async {
    setState(() => _isLoading = true);
    _showLoadingDialog();

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("username") ?? "";
    final carCode = prefs.getString("qr1") ?? "";

    if (username.isEmpty || carCode.isEmpty) {
      _hideLoadingDialog();
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Datos faltantes, intente nuevamente")),
      );
      return;
    }

    // 📌 Crear estructura de datos para enviar
    final Map<String, dynamic> formData = {
      "carCode": carCode,
      "username": username,
      "tipo": widget.tipo,
      "observaciones": _observationsController.text,
      for (var question in questions)
        question["key"]!: selectedAnswers[question["key"]] ?? "No",
    };

    try {
      await ApiService.fetchRequest("form", "POST", body: formData);
      if (widget.reassign) {
        await ApiService.fetchRequest("form", "POST", body: {...formData, "tipo": "ENTREGA"});
      }
      await ApiService.fetchRequest(widget.action, "PUT");

      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado con éxito")),
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScanScreen()));
    } catch (error) {
      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar formulario")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
