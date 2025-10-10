import 'package:flutter/material.dart';
import 'calendar_view.dart';
import 'analytics_view.dart';
import 'appointments_experts_list.dart';

class DashboardView extends StatefulWidget {
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;

  const DashboardView({
    super.key,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  int _calculateCycleDay() {
    final today = DateTime.now();
    final difference = today.difference(widget.firstDayOfPeriod).inDays;
    return (difference % widget.cycleLength) + 1;
  }

  DateTime _calculateNextPeriod() {
    final cycleDay = _calculateCycleDay();
    final daysUntilNext = widget.cycleLength - cycleDay;
    return DateTime.now().add(Duration(days: daysUntilNext));
  }

  String _getCurrentPhase() {
    final cycleDay = _calculateCycleDay();
    if (cycleDay <= 5) {
      return 'Menstrual Phase';
    } else if (cycleDay <= 13) {
      return 'Follicular Phase';
    } else if (cycleDay <= 15) {
      return 'Ovulation Phase';
    } else {
      return 'Luteal Phase';
    }
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens
    switch (index) {
      case 0:
      // Already on Home
        break;
      case 1:
      // Navigate to Calendar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarView(
              firstDayOfPeriod: widget.firstDayOfPeriod,
              cycleLength: widget.cycleLength,
            ),
          ),
        );
        break;
      case 2:
      // Navigate to Analytics/Insights
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AnalyticsView(),
          ),
        );
        break;
      case 3:
      // Navigate to Experts
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentsExpertsListView(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cycleDay = _calculateCycleDay();
    final nextPeriod = _calculateNextPeriod();
    final currentPhase = _getCurrentPhase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF2D2D2D),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF2D2D2D),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Your Daily Snapshot',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D2D),
                ),
              ),

              const SizedBox(height: 20),

              // Cycle Day Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF5DADA4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CYCLE DAY',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$cycleDay',
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        currentPhase,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Prediction Cards
              Row(
                children: [
                  // Next Period Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFE5EF),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFFE878B4),
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Predicted\nNext\nPeriod',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7A7A7A),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(nextPeriod),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Cycle Length Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FFFE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4F5F3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Color(0xFF5DADA4),
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Avg.\nCycle\nLength',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7A7A7A),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.cycleLength}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const Text(
                            'Days',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // AI Insights Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8E8E3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'AI-Powered Insights',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFD700),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'PREMIUM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD4A017),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get personalized insights based on your logged data using our advanced AI engine.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A7A7A),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Premium feature coming soon!'),
                              backgroundColor: Color(0xFF5DADA4),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text(
                          'Unlock AI Insights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5DADA4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF5DADA4),
          unselectedItemColor: const Color(0xFFB0B0B0),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Experts',
            ),
          ],
        ),
      ),
    );
  }
}
