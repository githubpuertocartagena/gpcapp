import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpcapp/screens/electric-cars/scanner_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => ScannerScreen()),
    GoRoute(path: '/confirm-car', builder: (context, state) => ScannerScreen()),
    GoRoute(path: '/occupied-car', builder: (context, state) => ScannerScreen()),
    GoRoute(path: '/leave-car', builder: (context, state) => ScannerScreen()),
    GoRoute(path: '/charging', builder: (context, state) => ScannerScreen()),
    GoRoute(path: '/charge-scanner', builder: (context, state) => ScannerScreen()),
  ],
);
