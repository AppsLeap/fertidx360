import 'package:flutter/material.dart';
import 'features/onboarding/views/role_selection_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FertiDx 360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5DADA4)),
        useMaterial3: true,
      ),
      home: const RoleSelectionView(),
    );
  }
}
