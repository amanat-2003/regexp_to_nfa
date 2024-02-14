import 'package:regexp_to_nfa/app_colors.dart';
import 'package:regexp_to_nfa/nfa_diagram_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NFADiagramScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: AppColors.lightColorScheme,
      )
    );
  }
}

