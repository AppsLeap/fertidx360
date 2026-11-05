import 'package:flutter/material.dart';
import 'package:ferti_360/features/auth/views/auth_signup_view.dart'; // Ungaloda folder structure-ku etha maari path kuduthukonga
import 'package:ferti_360/core/constants/app_colors.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Matching onboarding background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo matching onboarding view
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(height: 24),
              
              // App Title matching onboarding style[cite: 1]
              const Text(
                'Welcome to FertiDx\n360',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTeal, // Matching teal color[cite: 1]
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                'Select your portal to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textGrey, // Matching description text color[cite: 1]
                ),
              ),
              const SizedBox(height: 48),
             // Patient / User Option
_RoleCard(
  title: 'Patient / User',
  subtitle: 'Track your cycle, symptoms & book appointments',
  icon: Icons.person_outline_rounded,
  color: AppColors.primaryTeal, // Primary Teal[cite: 1]
  onTap: () {
    // Navigate to AuthSignupView to get Email and Password first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthSignupView(role: 'Patient'),
      ),
    );
  },
),
const SizedBox(height: 16),
              

              // Doctor / Expert Option (In Progress State)[cite: 2]
              _RoleCard(
                title: 'Doctor / Expert',
                subtitle: 'Manage patient consultations and schedules',
                icon: Icons.medical_services_outlined,
                color: AppColors.primaryTeal ,// Primary Teal[cite: 1]
                onTap: () {
                  // Show "In Progress" dialog for future feature[cite: 2]
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Doctor Portal'),
                      content: const Text(
                        'This feature is currently under development and will be available soon!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A7A7A), //[cite: 1]
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}