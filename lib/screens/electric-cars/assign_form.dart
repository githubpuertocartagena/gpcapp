import 'package:flutter/material.dart';

class ElectricFormScreen extends StatefulWidget {
  @override
  _ElectricFormScreenState createState() => _ElectricFormScreenState();
}


class _ElectricFormScreenState extends State<ElectricFormScreen> {
  final List<Map<String, String>> questions = [
    {"question": "¿El barco MSC Aurora está listo para descargar?"},
    {"question": "¿El Evergreen Express ha llegado a tiempo?"},
    {"question": "¿El Blue Ocean ha completado su inspección?"},
  ];

  Map<int, bool?> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Puerto de Cartagena')),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question['question']!,
                        style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswers[index] == true ? Colors.green : Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedAnswers[index] = true;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text('Sí', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswers[index] == false ? Colors.red : Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedAnswers[index] = false;
                            });
                          },
                          child: Row(
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
    );
  }
}
