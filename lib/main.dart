import 'package:flutter/material.dart';
import 'screens/main_shell_screen.dart';

void main() {
  runApp(const SolectricityApp());
}

class SolectricityApp extends StatelessWidget {
  const SolectricityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'সূর্য বিদ্যুৎ - Solectricity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber.shade700,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const MainShellScreen(),
    );
  }
}