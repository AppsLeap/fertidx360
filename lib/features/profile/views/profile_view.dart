import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ferti_360/features/onboarding/views/role_selection_view.dart'; // Ungaloda path-ku etha maari import kuduthukonga

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isLoading = true;
  Map<String, dynamic> _profileData = {};
  String _errorMessage = '';
  final String _currentPassword = '••••••••'; // Default mask for security

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Fetch user and patient profile data safely
  Future<void> _fetchProfileData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'No user logged in';
          _isLoading = false;
        });
        return;
      }

      // 1. Fetch user table data safely using maybeSingle
      final userData = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // 2. Fetch patient profiles table data safely using maybeSingle
      final profileData = await Supabase.instance.client
          .from('patient_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      setState(() {
        _profileData = {
          'email': user.email ?? 'N/A',
          ...?userData,
          ...?profileData,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  void _showChangePasswordDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5DADA4),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (passwordController.text.trim().isNotEmpty) {
                  try {
                    await Supabase.instance.client.auth.updateUser(
                      UserAttributes(password: passwordController.text.trim()),
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password updated successfully!')),
                      );
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
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Logout function to clear session and navigate to RoleSelectionView
  Future<void> _handleLogout() async {
    try {
      // 1. Sign out from Supabase
      await Supabase.instance.client.auth.signOut();

      if (mounted) {
        // 2. Navigate to RoleSelectionView and clear all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const RoleSelectionView(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Profile'),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF5DADA4)),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Profile'),
        ),
        body: Center(
          child: Text(
            'Error loading profile: $_errorMessage',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final String email = _profileData['email'] ?? 'N/A';
    final String role = _profileData['role'] ?? 'Patient';
    final int age = _profileData['age'] ?? 0;
    final String firstDayOfPeriod = _profileData['first_day_of_period'] ?? '';
    final int cycleLength = _profileData['cycle_length'] ?? 0;
    final int periodDuration = _profileData['period_duration'] ?? 0;
    
    // Parse symptoms safely from JSON / List
    final dynamic rawSymptoms = _profileData['selected_symptoms'];
    List<String> selectedSymptoms = [];
    if (rawSymptoms is List) {
      selectedSymptoms = rawSymptoms.map((e) => e.toString()).toList();
    }

    final dynamic rawCategorized = _profileData['categorized_symptoms'];
    Map<String, List<String>> categorizedSymptoms = {};
    if (rawCategorized is Map) {
      rawCategorized.forEach((key, value) {
        if (value is List) {
          categorizedSymptoms[key.toString()] = value.map((e) => e.toString()).toList();
        }
      });
    }

    final String otherIssues = _profileData['other_issues'] ?? '';

    final bool hasCategorizedData = categorizedSymptoms.values.any((list) => list.isNotEmpty);
    final bool hasFlatData = selectedSymptoms.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2D2D2D),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'FertiDx 360',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5DADA4),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Profile Avatar
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF5DADA4).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF5DADA4),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 50,
                color: Color(0xFF5DADA4),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 6),

            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE878B4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Account Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      Icons.email_outlined, 'Email / Username', email),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  Row(
                    children: [
                      const Icon(Icons.lock_outline,
                          color: Color(0xFF5DADA4), size: 22),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF7A7A7A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        _currentPassword,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            size: 18, color: Color(0xFF5DADA4)),
                        onPressed: _showChangePasswordDialog,
                        tooltip: 'Change Password',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Health & Cycle Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health & Cycle Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      Icons.cake_outlined, 'Age', '$age Years'),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Last Period Start',
                      _formatDate(firstDayOfPeriod)),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(Icons.refresh_rounded, 'Avg. Cycle Length',
                      '$cycleLength Days'),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(Icons.access_time_rounded,
                      'Avg. Period Duration', '$periodDuration Days'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Symptoms & Other Issues Categorized Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Symptoms & Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!hasCategorizedData && !hasFlatData)
                    const Text(
                      'No symptoms selected',
                      style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 14),
                    )
                  else if (hasCategorizedData) ...[
                    if ((categorizedSymptoms['Pre-Menstrual'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'Before Menstruation (Pre-Menstrual)',
                        categorizedSymptoms['Pre-Menstrual']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if ((categorizedSymptoms['During Menstruation'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'During Menstruation',
                        categorizedSymptoms['During Menstruation']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if ((categorizedSymptoms['Post-Menstrual'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'After Menstruation (Post-Menstrual)',
                        categorizedSymptoms['Post-Menstrual']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ] else ...[
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: selectedSymptoms.map((symptom) {
                        return Chip(
                          label: Text(symptom),
                          backgroundColor:
                              const Color(0xFF5DADA4).withOpacity(0.15),
                          labelStyle: const TextStyle(
                            color: Color(0xFF2D2D2D),
                            fontSize: 13,
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  if (otherIssues.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Other Issues / Notes:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      otherIssues,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Log Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGroup(String categoryTitle, List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryTitle,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5DADA4),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: symptoms.map((symptom) {
            return Chip(
              label: Text(symptom),
              backgroundColor: const Color(0xFF5DADA4).withOpacity(0.12),
              labelStyle: const TextStyle(
                color: Color(0xFF2D2D2D),
                fontSize: 13,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5DADA4), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF7A7A7A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}