import 'package:flutter/material.dart';
import 'onboarding_complete_view.dart';

class OnboardingCycleInfo extends StatefulWidget {
  final int age;

  const OnboardingCycleInfo({
    super.key,
    required this.age,
  });

  @override
  State<OnboardingCycleInfo> createState() => _OnboardingCycleInfoState();
}

class _OnboardingCycleInfoState extends State<OnboardingCycleInfo> {
  final TextEditingController _cycleLengthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _cycleLengthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5DADA4),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D2D2D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '15-09-2025';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final cycleLength = int.parse(_cycleLengthController.text);

      if (cycleLength < 21 || cycleLength > 35) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cycle length should be between 21 and 35 days'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Navigate to complete screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingCompleteView(
            age: widget.age,
            firstDayOfPeriod: _selectedDate!,
            cycleLength: cycleLength,
          ),
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the first day of your last period'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Title
                const Text(
                  'Tell us about your cycle',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),

                const SizedBox(height: 40),

                // Date Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'First day of your last period',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDate != null
                                    ? const Color(0xFF2D2D2D)
                                    : const Color(0xFFB0B0B0),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Color(0xFF7A7A7A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Cycle Length Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Average cycle length (days)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cycleLengthController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2D2D2D),
                      ),
                      decoration: InputDecoration(
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
                        hintText: '28',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter cycle length';
                        }
                        final length = int.tryParse(value);
                        if (length == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const Spacer(),

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
      ),
    );
  }
}
