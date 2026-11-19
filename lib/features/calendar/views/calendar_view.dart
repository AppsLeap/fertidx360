import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:ferti_360/core/constants/app_colors.dart';
import '../widgets/daily_log_modal_view.dart';

class CalendarContent extends StatefulWidget {
  final DateTime firstDayOfPeriod;
  final int cycleLength;

  // Dates on which symptoms have been logged
  final Set<DateTime> symptomsLoggedDays;

  const CalendarContent({
    super.key,
    required this.firstDayOfPeriod,
    required this.cycleLength,
    this.symptomsLoggedDays = const {},
  });

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  
  // Local mutable set to keep track of logged symptoms and update UI dynamically
  late Set<DateTime> _symptomsDays;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    // Initialize local set with widget parameter
    _symptomsDays = Set.from(widget.symptomsLoggedDays);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Normalize date to remove time values
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Check whether symptoms are logged
  bool _hasSymptoms(DateTime day) {
    return _symptomsDays.any(
      (date) => isSameDay(date, day),
    );
  }

  // Calculate cycle day
  int? _getCycleDay(DateTime day) {
    if (widget.cycleLength <= 0) return null;

    final difference = _normalizeDate(day)
        .difference(_normalizeDate(widget.firstDayOfPeriod))
        .inDays;

    return ((difference % widget.cycleLength) +
            widget.cycleLength) %
        widget.cycleLength;
  }

  // Check period days
  bool _isPeriodDay(DateTime day) {
    final cycleDay = _getCycleDay(day);
    if (cycleDay == null) return false;
    return cycleDay < 5;
  }

  // Check fertile days
  bool _isFertileDay(DateTime day) {
    final cycleDay = _getCycleDay(day);
    if (cycleDay == null) return false;
    return cycleDay >= 10 && cycleDay < 18;
  }

  // Check ovulation days
  bool _isOvulationDay(DateTime day) {
    final cycleDay = _getCycleDay(day);
    if (cycleDay == null) return false;
    return cycleDay >= 13 && cycleDay < 15;
  }

  // Get calendar day color
  Color? _getDayColor(DateTime day) {
    if (_isPeriodDay(day)) {
      return AppColors.periodColor;
    } else if (_isOvulationDay(day)) {
      return AppColors.ovulationColor;
    } else if (_isFertileDay(day)) {
      return AppColors.fertileColor;
    }
    return null;
  }

  // Build calendar circle with half-circle support for symptoms
  Widget _buildDayCircle({
    required DateTime day,
    required bool isToday,
  }) {
    final bool hasSymptoms = _hasSymptoms(day);
    final Color? dayColor = _getDayColor(day);
    final Color symptomsColor = AppColors.symptomsColor;
    final Color borderColor = AppColors.ovulationColor;

    // Period / Ovulation / Fertile + Symptoms -> Perfect Circle Split View
    if (hasSymptoms && dayColor != null) {
      return Container(
        margin: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1.0, // Forces equal width and height to prevent stretching into an oval
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(
                      color: borderColor,
                      width: 2,
                    )
                  : null,
            ),
            child: ClipOval(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: dayColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: symptomsColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Normal day + Symptoms (Full Circle)
    if (hasSymptoms) {
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: symptomsColor,
          border: isToday
              ? Border.all(
                  color: borderColor,
                  width: 2,
                )
              : null,
        ),
      );
    }

    // Normal Period / Ovulation / Fertile day
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dayColor ?? Colors.transparent,
        border: isToday
            ? Border.all(
                color: borderColor,
                width: 2,
              )
            : null,
      ),
    );
  }

  // Build calendar day with date number
  Widget _buildCalendarDay({
    required DateTime day,
    required bool isToday,
    required bool isSelected,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildDayCircle(
          day: day,
          isToday: isToday,
        ),
        Text(
          '${day.day}',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: isSelected || isToday
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Show daily log modal and handle returned data
  void _showDailyLogModal(DateTime selectedDay) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DailyLogModalView(
          selectedDate: selectedDay,
        );
      },
    );

    // Check if result is received and symptoms/data were saved
    if (result != null && result['date'] != null) {
      final DateTime loggedDate = _normalizeDate(result['date']);
      
      // Optional: Check if symptoms or flow were logged to decide whether to mark symptoms day
      final List symptomsList = result['symptoms'] ?? [];
      final String? periodFlow = result['period_flow'];

      setState(() {
        // If user selected symptoms or a flow, add to logged days
        if (symptomsList.isNotEmpty || periodFlow != null) {
          _symptomsDays.add(loggedDate);
        }
      });
    }
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
          color: AppColors.calendarBackground,
          child: Container(
            color: AppColors.white,
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
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(
                    day: day,
                    isToday: isSameDay(day, DateTime.now()),
                    isSelected: isSameDay(_selectedDay, day),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(
                    day: day,
                    isToday: true,
                    isSelected: isSameDay(_selectedDay, day),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildCalendarDay(
                    day: day,
                    isToday: isSameDay(day, DateTime.now()),
                    isSelected: true,
                  );
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppColors.textColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppColors.textColor,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                ),
                weekendStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}