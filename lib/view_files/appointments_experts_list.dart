import 'package:flutter/material.dart';
import 'appointments_bookings.dart';

class Expert {
  final String name;
  final String specialization;
  final Color avatarColor;

  Expert({
    required this.name,
    required this.specialization,
    required this.avatarColor,
  });
}

class AppointmentsExpertsListView extends StatelessWidget {
  final List<Expert> experts = [
    Expert(
      name: 'Dr. Emily Carter',
      specialization: 'Fertility Specialist',
      avatarColor: const Color(0xFF6BA5D5),
    ),
    Expert(
      name: 'Dr. Johnathan Reed',
      specialization: 'Gynecologist',
      avatarColor: const Color(0xFFE878B4),
    ),
    Expert(
      name: 'Dr. Maria Garcia',
      specialization: 'Nutritionist',
      avatarColor: const Color(0xFF9C8FE8),
    ),
  ];

  AppointmentsExpertsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF5),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule an\nAppointment',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. Choose an Expert',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 16),
            ...experts.map((expert) => _buildExpertCard(context, expert)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertCard(BuildContext context, Expert expert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentsBookingsView(expert: expert),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: expert.avatarColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expert.specialization,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB0B0B0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
