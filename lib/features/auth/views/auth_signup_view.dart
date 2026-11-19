import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ferti_360/features/onboarding/views/onboarding_view.dart';
import 'package:ferti_360/features/appointments/views/main_scaffold.dart'; // MainScaffold import for direct routing

class AuthSignupView extends StatefulWidget {
  final String role; // 'Patient' or 'Doctor'

  const AuthSignupView({
    super.key,
    required this.role,
  });

  @override
  State<AuthSignupView> createState() => _AuthSignupViewState();
}

class _AuthSignupViewState extends State<AuthSignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        bool isNewUser = false;
        User? user;

        try {
          // 1. Try to sign up user in Supabase Auth
          final AuthResponse res = await Supabase.instance.client.auth.signUp(
            email: email,
            password: password,
          );

          user = res.user;

          if (user != null) {
            isNewUser = true;
            // Insert user record into public 'users' table using upsert to avoid duplicates
            await Supabase.instance.client.from('users').upsert({
              'id': user.id,
              'email': email,
              'role': widget.role,
            });
          }
        } catch (signupError) {
          // 2. If sign up fails (e.g., email already registered), fallback to Sign In!
          final AuthResponse signinRes = await Supabase.instance.client.auth.signInWithPassword(
            email: email,
            password: password,
          );
          user = signinRes.user;
          isNewUser = false;
        }

        if (user != null && mounted) {
          if (isNewUser) {
            // New user goes through the Onboarding flow
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingView(),
              ),
              (route) => false,
            );
          } else {
            // Existing user: check if their patient profile already exists
            final profileData = await Supabase.instance.client
                .from('patient_profiles')
                .select()
                .eq('user_id', user.id)
                .maybeSingle();

            if (mounted) {
              if (profileData == null) {
                // If profile is not found, take them to complete onboarding
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingView(),
                  ),
                  (route) => false,
                );
              } else {
                // Parse existing profile data and navigate directly to MainScaffold
                final int age = profileData['age'] ?? 25;
                final DateTime firstDayOfPeriod = DateTime.parse(
                  profileData['first_day_of_period'] ?? DateTime.now().toIso8601String(),
                );
                final int cycleLength = profileData['cycle_length'] ?? 28;
                final List<String> selectedSymptoms = 
                    List<String>.from(profileData['selected_symptoms'] ?? []);
                final String otherIssues = profileData['other_issues'] ?? '';

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScaffold(
                      age: age,
                      firstDayOfPeriod: firstDayOfPeriod,
                      cycleLength: cycleLength,
                      selectedSymptoms: selectedSymptoms,
                      otherIssues: otherIssues,
                    ),
                  ),
                  (route) => false,
                );
              }
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0), // Matching onboarding background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo matching onboarding view
                Image.asset(
                  'assets/logo.png',
                  width: 60,
                  height: 60,
                ),

                const SizedBox(height: 32),

                // Title matching onboarding text style
                Text(
                  'Create Account\n(${widget.role})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5DADA4), // Matching teal color
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 36),

                // Email / Username Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email / Username',
                    labelStyle: const TextStyle(color: Color(0xFF7A7A7A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF7A7A7A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Continue Button matching onboarding button style
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5DADA4), // Matching teal color
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
                            'Continue',
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
      ),
    );
  }
}