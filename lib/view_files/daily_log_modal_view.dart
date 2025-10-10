import 'package:flutter/material.dart';

class DailyLogModalView extends StatefulWidget {
  final DateTime selectedDate;

  const DailyLogModalView({
    super.key,
    required this.selectedDate,
  });

  @override
  State<DailyLogModalView> createState() => _DailyLogModalViewState();
}

class _DailyLogModalViewState extends State<DailyLogModalView> {
  String? _selectedPeriodFlow;
  bool _positiveOvulationTest = false;
  final Set<String> _selectedSymptoms = {};
  String? _selectedMood;
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _buildChipButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? const Color(0xFF5DADA4))
              : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF7A7A7A),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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

  void _handleSave() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily log saved successfully!'),
        backgroundColor: Color(0xFF5DADA4),
      ),
    );
  }

  @override
  void dispose() {
    _sleepController.dispose();
    _weightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Log for ${_formatDate(widget.selectedDate)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
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
                    _buildSectionTitle('Period Flow'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Spotting', 'Light', 'Medium', 'Heavy'].map((flow) {
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
                    _buildSectionTitle('Symptoms'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Cramps',
                        'Headache',
                        'Fatigue',
                        'Bloating',
                        'Nausea',
                        'Tender Breasts',
                      ].map((symptom) {
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
                    const SizedBox(height: 24),
                    _buildSectionTitle('Mood'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Happy', 'Calm', 'Anxious', 'Moody'].map((mood) {
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
                                color: Color(0xFF7A7A7A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5DADA4),
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
