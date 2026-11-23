
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ferti_360/features/appointments/views/main_scaffold.dart';
import 'package:ferti_360/features/onboarding/views/role_selection_view.dart';
import 'package:ferti_360/features/onboarding/views/onboarding_view.dart';
import 'package:ferti_360/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
    throw Exception(
      'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY must be configured.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  final session =
      Supabase.instance.client.auth.currentSession;

  final notificationService = NotificationService();

  runApp(
    MyApp(
      isLoggedIn: session != null,
      notificationService: notificationService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationProvider(
      service: notificationService,
      child: MaterialApp(
        title: 'FertiDx 360',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5DADA4),
          ),
          useMaterial3: true,
        ),

        home: isLoggedIn
            ? const MainScaffoldLoader()
            : const RoleSelectionView(),
      ),
    );
  }
}

class MainScaffoldLoader extends StatelessWidget {
  const MainScaffoldLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return const RoleSelectionView();
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: supabase
          .from('patient_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5DADA4),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load your profile.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>
                                const MainScaffoldLoader(),
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final data = snapshot.data;

        // If patient profile does not exist,
        // navigate to onboarding.
        if (data == null) {
          return const OnboardingView();
        }

        final int age = (data['age'] as num?)?.toInt() ?? 25;

        final DateTime firstDayOfPeriod =
            DateTime.tryParse(
              data['first_day_of_period']?.toString() ?? '',
            ) ??
            DateTime.now();

        final int cycleLength =
            (data['cycle_length'] as num?)?.toInt() ?? 28;

        final List<String> selectedSymptoms =
            (data['selected_symptoms'] as List<dynamic>?)
                    ?.map((item) => item.toString())
                    .toList() ??
                [];

        final String otherIssues =
            data['other_issues']?.toString() ?? '';

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
