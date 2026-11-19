import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ferti_360/features/appointments/views/main_scaffold.dart';

class OnboardingCompleteView extends StatefulWidget {
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;
  final int periodDuration;
  final List<String> selectedSymptoms;
  final Map<String, List<String>> categorizedSymptoms;
  final String otherIssues;

  const OnboardingCompleteView({
    super.key,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
    required this.periodDuration,
    required this.selectedSymptoms,
    this.categorizedSymptoms = const {},
    required this.otherIssues,
  });

  @override
  State<OnboardingCompleteView> createState() => _OnboardingCompleteViewState();
}

class _OnboardingCompleteViewState extends State<OnboardingCompleteView> {
  bool _isLoading = false;

  Future<void> _handleStartJourney(BuildContext context) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      // Insert patient profile using the authenticated user's ID
      await Supabase.instance.client.from('patient_profiles').upsert({
        'user_id': user.id,
        'age': widget.age,
        'first_day_of_period': widget.firstDayOfPeriod.toIso8601String().split('T')[0],
        'cycle_length': widget.cycleLength,
        'period_duration': widget.periodDuration,
        'selected_symptoms': widget.selectedSymptoms,
        'categorized_symptoms': widget.categorizedSymptoms,
        'other_issues': widget.otherIssues,
      });
    } else {
      print('Error: No active user session found during onboarding!');
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScaffold(
            age: widget.age,
            firstDayOfPeriod: widget.firstDayOfPeriod,
            cycleLength: widget.cycleLength,
            selectedSymptoms: widget.selectedSymptoms,
            categorizedSymptoms: widget.categorizedSymptoms,
            otherIssues: widget.otherIssues,
          ),
        ),
        (route) => false,
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo
              Image.asset(
                'assets/logo.png',
                width: 50,
                height: 50,
              ),

              const SizedBox(height: 24),

              // Progress Indicator - Full
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF5DADA4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const Spacer(flex: 2),

              // Success Checkmark
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF5DADA4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'You\'re all set!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'Your personalized fertility dashboard is\nready for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7A7A7A),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // Start Journey Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleStartJourney(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE878B4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Start My Journey',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}