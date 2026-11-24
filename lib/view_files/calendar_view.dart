import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'daily_log_modal_view.dart';

class CalendarContent extends StatefulWidget {
  final DateTime firstDayOfPeriod;
  final int cycleLength;

  const CalendarContent({
    super.key,
    required this.firstDayOfPeriod,
    required this.cycleLength,
  });

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isPeriodDay(DateTime day) {
    final difference = day.difference(widget.firstDayOfPeriod).inDays;
    final cycleDay = (difference % widget.cycleLength);
    return cycleDay >= 0 && cycleDay < 5;
  }

  bool _isFertileDay(DateTime day) {
    final difference = day.difference(widget.firstDayOfPeriod).inDays;
    final cycleDay = (difference % widget.cycleLength);
    return cycleDay >= 10 && cycleDay < 18;
  }

  bool _isOvulationDay(DateTime day) {
    final difference = day.difference(widget.firstDayOfPeriod).inDays;
    final cycleDay = (difference % widget.cycleLength);
    return cycleDay >= 13 && cycleDay < 15;
  }

  Color? _getDayColor(DateTime day) {
    if (_isPeriodDay(day)) {
      return const Color(0xFFFFD4E5);
    } else if (_isOvulationDay(day)) {
      return const Color(0xFF5DADA4);
    } else if (_isFertileDay(day)) {
      return const Color(0xFFB8E6E1);
    }
    return null;
  }

  void _showDailyLogModal(DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyLogModalView(selectedDate: selectedDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: false,
      thickness: 4,
      radius: const Radius.circular(2),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: const Color(0xFFF0FFF5),
          child: Container(
            color: Colors.white,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showDailyLogModal(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF5DADA4),
                    width: 2,
                  ),
                  color: Colors.transparent,
                ),
                selectedDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5DADA4),
                ),
                weekendDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final color = _getDayColor(day);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: color != null ? const Color(0xFF2D2D2D) : const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  final color = _getDayColor(day);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: const Color(0xFF5DADA4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF2D2D2D),
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7A7A7A),
                ),
                weekendStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}