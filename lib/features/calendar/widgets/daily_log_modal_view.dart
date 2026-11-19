import 'package:flutter/material.dart';
import 'package:ferti_360/core/constants/app_colors.dart';

class DailyLogModalView extends StatefulWidget {
  final DateTime selectedDate;

  const DailyLogModalView({
    super.key,
    required this.selectedDate,
  });

  @override
  State<DailyLogModalView> createState() =>
      _DailyLogModalViewState();
}

class _DailyLogModalViewState extends State<DailyLogModalView> {
  String? _selectedPeriodFlow;
  bool _positiveOvulationTest = false;
  final Set<String> _selectedSymptoms = {};
  String? _selectedMood;

  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _otherSymptomsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Format selected date
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // Reusable selection chip
  Widget _buildChipButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppColors.primaryTeal)
              : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors.textGrey,
          ),
        ),
      ),
    );
  }

  // Reusable text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFB0B0B0),
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  // Save daily log and return data to calendar
  void _handleSave() {
    final Map<String, dynamic> result = {
      'date': DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      ),
      'period_flow': _selectedPeriodFlow,
      'ovulation_test': _positiveOvulationTest,
      'symptoms': _selectedSymptoms.toList(),
      'other_symptoms': _otherSymptomsController.text.trim(),
      'mood': _selectedMood,
      'sleep': _sleepController.text.trim(),
      'weight': _weightController.text.trim(),
    };

    // Return saved data to CalendarContent
    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _sleepController.dispose();
    _weightController.dispose();
    _otherSymptomsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableSymptoms = [
      'Cramps', 'Headache', 'Fatigue', 'Bloating', 'Nausea',
      'Tender Breasts', 'Acne', 'Backache', 'Mood Swings', 'Dizziness', 'Insomnia',
    ];

    final List<String> availableMoods = [
      'Happy', 'Calm', 'Anxious', 'Moody', 'Sad', 'Energetic',
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Log for ${_formatDate(widget.selectedDate)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: false,
              thickness: 4,
              radius: const Radius.circular(2),
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period Flow
                    _buildSectionTitle('Period Flow'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Spotting', 'Light', 'Medium', 'Heavy',
                      ].map((flow) {
                        return _buildChipButton(
                          label: flow,
                          isSelected: _selectedPeriodFlow == flow,
                          onTap: () {
                            setState(() {
                              _selectedPeriodFlow = flow;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Ovulation Test
                    _buildSectionTitle('Ovulation Test'),
                    _buildChipButton(
                      label: 'Positive Test',
                      isSelected: _positiveOvulationTest,
                      onTap: () {
                        setState(() {
                          _positiveOvulationTest = !_positiveOvulationTest;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Symptoms
                    _buildSectionTitle('Symptoms'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableSymptoms.map((symptom) {
                        return _buildChipButton(
                          label: symptom,
                          isSelected: _selectedSymptoms.contains(symptom),
                          onTap: () {
                            setState(() {
                              if (_selectedSymptoms.contains(symptom)) {
                                _selectedSymptoms.remove(symptom);
                              } else {
                                _selectedSymptoms.add(symptom);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Other Symptoms
                    TextField(
                      controller: _otherSymptomsController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Other Symptoms / Notes',
                        labelStyle: const TextStyle(
                          color: AppColors.textGrey,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Mood
                    _buildSectionTitle('Mood'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableMoods.map((mood) {
                        return _buildChipButton(
                          label: mood,
                          isSelected: _selectedMood == mood,
                          onTap: () {
                            setState(() {
                              _selectedMood = mood;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Sleep and Weight
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Sleep (hours)'),
                              _buildTextField(
                                controller: _sleepController,
                                hint: '8',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Weight (lbs)'),
                              _buildTextField(
                                controller: _weightController,
                                hint: '140',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Cancel and Save buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}