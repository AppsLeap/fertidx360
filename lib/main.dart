import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ferti_360/features/appointments/views/main_scaffold.dart';
import 'package:ferti_360/features/onboarding/views/role_selection_view.dart';
import 'package:ferti_360/features/onboarding/views/onboarding_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jxcuaehaekhcvzwdrmgl.supabase.co', // Corrected URL syntax
    anonKey: 'sb_publishable_sZSqQk_eDBj2QsWu6l_Hag_ln5F1M4d',
  );

  // Check active session on app launch
  final session = Supabase.instance.client.auth.currentSession;

  runApp(MyApp(isLoggedIn: session != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FertiDx 360',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5DADA4)),
        useMaterial3: true,
      ),
      // Route based on authentication session
      home: isLoggedIn ? const MainScaffoldLoader() : const RoleSelectionView(),
    );
  }
}

// Widget to fetch user profile data and navigate accordingly
class MainScaffoldLoader extends StatelessWidget {
  const MainScaffoldLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const RoleSelectionView();
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: Supabase.instance.client
          .from('patient_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF5DADA4)),
            ),
          );
        }

        final data = snapshot.data;

        // If no profile data found, direct user to completing onboarding
        if (data == null) {
          return const OnboardingView();
        }

        // Parse retrieved values for MainScaffold
        final int age = data['age'] ?? 25;
        final DateTime firstDayOfPeriod = DateTime.parse(
          data['first_day_of_period'] ?? DateTime.now().toIso8601String(),
        );
        final int cycleLength = data['cycle_length'] ?? 28;
        final List<String> selectedSymptoms = 
            List<String>.from(data['selected_symptoms'] ?? []);
        final String otherIssues = data['other_issues'] ?? '';

        return MainScaffold(
          age: age,
          firstDayOfPeriod: firstDayOfPeriod,
          cycleLength: cycleLength,
          selectedSymptoms: selectedSymptoms,
          otherIssues: otherIssues,
        );
      },
    );
  }
}