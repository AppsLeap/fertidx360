import 'package:flutter/material.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../calendar/views/calendar_view.dart';
import '../../analytics/views/analytics_view.dart';
import 'appointments_experts_list.dart';
import 'package:ferti_360/features/profile/views/profile_view.dart';

class MainScaffold extends StatefulWidget {
  final int age;
  final DateTime firstDayOfPeriod;
  final int cycleLength;
  final List<String> selectedSymptoms;
  final Map<String, List<String>> categorizedSymptoms;
  final String otherIssues;

  const MainScaffold({
    super.key,
    required this.age,
    required this.firstDayOfPeriod,
    required this.cycleLength,
    this.selectedSymptoms = const [],
    this.categorizedSymptoms = const {},
    this.otherIssues = '',
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileView(
                    role: 'Patient',
                    email: 'user@fertidx360.com',
                    password: 'password123',
                    age: widget.age,
                    firstDayOfPeriod: widget.firstDayOfPeriod,
                    cycleLength: widget.cycleLength,
                    periodDuration: 5,
                    selectedSymptoms: widget.selectedSymptoms,
                    categorizedSymptoms: widget.categorizedSymptoms,
                    otherIssues: widget.otherIssues,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardContent(
            age: widget.age,
            firstDayOfPeriod: widget.firstDayOfPeriod,
            cycleLength: widget.cycleLength,
          ),
          CalendarContent(
            firstDayOfPeriod: widget.firstDayOfPeriod,
            cycleLength: widget.cycleLength,
          ),
          const AnalyticsContent(),
          const AppointmentsContent(),
        ],
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
              label: 'Charts',
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