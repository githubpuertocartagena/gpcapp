import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpcapp/screens/electric-cars/login_screen.dart';

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
    home: LoginScreen(),
    theme: ThemeData(
      primaryColor: Color(0xFF003A70), // Azul oscuro característico
      scaffoldBackgroundColor: Color(0xFFF4F4F4), // Fondo gris claro
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF003A70),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF003A70),
          fontSize: 20,
        ),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0075C9), // Azul más claro para contraste
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
  )));
}
