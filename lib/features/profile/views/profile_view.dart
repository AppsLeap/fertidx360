import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final String role;
  final String email;
  final String password;
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;
  final int periodDuration;
  final List<String> selectedSymptoms;
  final Map<String, List<String>> categorizedSymptoms;
  final String otherIssues;

  const ProfileView({
    super.key,
    required this.role,
    required this.email,
    required this.password,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
    required this.periodDuration,
    this.selectedSymptoms = const [],
    this.categorizedSymptoms = const {},
    this.otherIssues = '',
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String _currentPassword;

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.password;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _showChangePasswordDialog() {
    final TextEditingController passwordController =
        TextEditingController(text: _currentPassword);

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
              onPressed: () {
                if (passwordController.text.trim().isNotEmpty) {
                  setState(() {
                    _currentPassword = passwordController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password updated successfully!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCategorizedData = widget.categorizedSymptoms.values
        .any((list) => list.isNotEmpty);
    final bool hasFlatData = widget.selectedSymptoms.isNotEmpty;

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
              widget.email,
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
                widget.role,
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
                      Icons.email_outlined, 'Email / Username', widget.email),
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
                        '•' * _currentPassword.length,
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
                      Icons.cake_outlined, 'Age', '${widget.age} Years'),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Last Period Start',
                      _formatDate(widget.firstDayOfPeriod)),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(Icons.refresh_rounded, 'Avg. Cycle Length',
                      '${widget.cycleLength} Days'),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),
                  _buildInfoRow(Icons.access_time_rounded,
                      'Avg. Period Duration', '${widget.periodDuration} Days'),
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
                    if ((widget.categorizedSymptoms['Pre-Menstrual'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'Before Menstruation (Pre-Menstrual)',
                        widget.categorizedSymptoms['Pre-Menstrual']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if ((widget.categorizedSymptoms['During Menstruation'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'During Menstruation',
                        widget.categorizedSymptoms['During Menstruation']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if ((widget.categorizedSymptoms['Post-Menstrual'] ?? [])
                        .isNotEmpty) ...[
                      _buildCategoryGroup(
                        'After Menstruation (Post-Menstrual)',
                        widget.categorizedSymptoms['Post-Menstrual']!,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ] else ...[
                    // Fallback to simple list if only flat list was passed
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: widget.selectedSymptoms.map((symptom) {
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

                  if (widget.otherIssues.isNotEmpty) ...[
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
                      widget.otherIssues,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ],
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