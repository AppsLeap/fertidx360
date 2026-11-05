import 'package:flutter/material.dart';
import 'onboarding_complete_view.dart';

class OnboardingMenstrualCycleView extends StatefulWidget {
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;
  final int periodLength;

  const OnboardingMenstrualCycleView({
    super.key,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
    required this.periodLength,
  });

  @override
  State<OnboardingMenstrualCycleView> createState() =>
      _OnboardingMenstrualCycleViewState();
}

class _OnboardingMenstrualCycleViewState
    extends State<OnboardingMenstrualCycleView> {
  // Symptom lists
  final List<String> preMenstrualSymptoms = [
    'Abdominal pain',
    'Lower abdomen cramps',
    'Lower back pain',
    'Breast tenderness',
    'Mood swings',
    'Irritability',
    'Headache',
    'Fatigue',
    'Bloating',
    'Pimples/acne',
    'Sleep changes',
    'Food cravings',
    'Anxiety',
  ];

  final List<String> duringMenstruationSymptoms = [
    'Period cramps',
    'Heavy menstrual bleeding',
    'Light bleeding/spotting',
    'Back pain',
    'Leg pain',
    'Headache',
    'Nausea',
    'Diarrhea',
    'Constipation',
    'Dizziness',
    'Weakness',
    'Fatigue',
    'Bloating',
    'Difficulty concentrating',
    'Sleep disturbance',
  ];

  final List<String> postMenstrualSymptoms = [
    'Mild abdominal discomfort',
    'Fatigue',
    'Weakness due to blood loss',
    'Headache',
    'Mood changes',
    'Low energy levels',
  ];

  // Category wise selected symptoms storage
  final Set<String> _selectedPreSymptoms = {};
  final Set<String> _selectedDuringSymptoms = {};
  final Set<String> _selectedPostSymptoms = {};

  final TextEditingController _otherIssuesController = TextEditingController();

  @override
  void dispose() {
    _otherIssuesController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom, String category) {
    setState(() {
      if (category == 'Pre-Menstrual') {
        if (_selectedPreSymptoms.contains(symptom)) {
          _selectedPreSymptoms.remove(symptom);
        } else {
          _selectedPreSymptoms.add(symptom);
        }
      } else if (category == 'During Menstruation') {
        if (_selectedDuringSymptoms.contains(symptom)) {
          _selectedDuringSymptoms.remove(symptom);
        } else {
          _selectedDuringSymptoms.add(symptom);
        }
      } else if (category == 'Post-Menstrual') {
        if (_selectedPostSymptoms.contains(symptom)) {
          _selectedPostSymptoms.remove(symptom);
        } else {
          _selectedPostSymptoms.add(symptom);
        }
      }
    });
  }

  void _handleNext() {
    // Combine into structured map for categories
    final Map<String, List<String>> categorizedSymptoms = {
      'Pre-Menstrual': _selectedPreSymptoms.toList(),
      'During Menstruation': _selectedDuringSymptoms.toList(),
      'Post-Menstrual': _selectedPostSymptoms.toList(),
    };

    // Maintain flat list for backwards compatibility
    final List<String> allSelected = [
      ..._selectedPreSymptoms,
      ..._selectedDuringSymptoms,
      ..._selectedPostSymptoms,
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingCompleteView(
          age: widget.age,
          firstDayOfPeriod: widget.firstDayOfPeriod,
          cycleLength: widget.cycleLength,
          periodDuration: widget.periodLength,
          selectedSymptoms: allSelected,
          categorizedSymptoms: categorizedSymptoms,
          otherIssues: _otherIssuesController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),

              const SizedBox(height: 20),

              // Progress Indicator
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DADA4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DADA4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DADA4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DADA4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // Title
              const Text(
                'Menstrual Cycle Symptoms',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the symptoms you commonly experience across your cycle phases.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                ),
              ),

              const SizedBox(height: 24),

              // 1st Pre-Menstrual Symptoms
              _buildExpandableSection(
                '1. Pre-Menstrual Symptoms',
                preMenstrualSymptoms,
                _selectedPreSymptoms,
                'Pre-Menstrual',
              ),

              const SizedBox(height: 16),

              // 2nd During Menstruation
              _buildExpandableSection(
                '2. During Menstruation',
                duringMenstruationSymptoms,
                _selectedDuringSymptoms,
                'During Menstruation',
              ),

              const SizedBox(height: 16),

              // 3rd Post-Menstrual Symptoms
              _buildExpandableSection(
                '3. Post-Menstrual Symptoms',
                postMenstrualSymptoms,
                _selectedPostSymptoms,
                'Post-Menstrual',
              ),

              const SizedBox(height: 24),

              // Other Issues Text Field
              const Text(
                'Other Issues / Notes',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5A5A5A),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _otherIssuesController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D2D2D),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Type any other specific issues or symptoms here...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB0B0B0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 40),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5DADA4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<String> symptoms,
    Set<String> selectedSet,
    String category,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D2D2D),
          ),
        ),
        iconColor: const Color(0xFF5DADA4),
        collapsedIconColor: const Color(0xFF7A7A7A),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildChipGroup(symptoms, selectedSet, category),
          ),
        ],
      ),
    );
  }

  Widget _buildChipGroup(
    List<String> symptoms,
    Set<String> selectedSet,
    String category,
  ) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: symptoms.map((symptom) {
        final isSelected = selectedSet.contains(symptom);
        return FilterChip(
          label: Text(symptom),
          selected: isSelected,
          selectedColor: const Color(0xFF5DADA4).withOpacity(0.2),
          checkmarkColor: const Color(0xFF5DADA4),
          backgroundColor: const Color(0xFFF5F5F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? const Color(0xFF5DADA4) : Colors.transparent,
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF2D2D2D) : const Color(0xFF5A5A5A),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          onSelected: (bool selected) {
            _toggleSymptom(symptom, category);
          },
        );
      }).toList(),
    );
  }
}