import 'package:flutter/material.dart';
import 'dashboard_view.dart';

class OnboardingCompleteView extends StatelessWidget {
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;

  const OnboardingCompleteView({
    super.key,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
  });

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
                decoration: BoxDecoration(
                  color: const Color(0xFF5DADA4),
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
                  // Update the button onPressed
                  onPressed: () {
                    // Navigate to dashboard and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardView(
                          age: age,
                          firstDayOfPeriod: firstDayOfPeriod,
                          cycleLength: cycleLength,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE878B4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
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
