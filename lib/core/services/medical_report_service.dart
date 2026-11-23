import 'package:flutter/material.dart';
import 'report_download_stub.dart'
    if (dart.library.html) 'report_download_web.dart';

class DailyLogEntry {
  final DateTime date;
  final String? periodFlow;
  final bool ovulationTest;
  final List<String> symptoms;
  final String otherSymptoms;
  final String? mood;
  final String sleep;
  final String weight;

  const DailyLogEntry({
    required this.date,
    this.periodFlow,
    required this.ovulationTest,
    required this.symptoms,
    required this.otherSymptoms,
    this.mood,
    required this.sleep,
    required this.weight,
  });

  factory DailyLogEntry.fromMap(Map<String, dynamic> map) {
    final rawDate = map['date'];
    final DateTime parsedDate = rawDate is DateTime
        ? rawDate
        : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();

    final rawSymptoms = map['symptoms'];
    final List<String> parsedSymptoms = rawSymptoms is List
        ? rawSymptoms.map((e) => e.toString()).toList()
        : const [];

    return DailyLogEntry(
      date: DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
      periodFlow: map['period_flow']?.toString(),
      ovulationTest: map['ovulation_test'] == true,
      symptoms: parsedSymptoms,
      otherSymptoms: (map['other_symptoms'] ?? '').toString().trim(),
      mood: map['mood']?.toString(),
      sleep: (map['sleep'] ?? '').toString().trim(),
      weight: (map['weight'] ?? '').toString().trim(),
    );
  }
}

class MedicalReportService extends ChangeNotifier {
  final List<DailyLogEntry> _dailyLogs = [];
  final Set<String> _permittedExpertNames = {};

  List<DailyLogEntry> get dailyLogs => List.unmodifiable(_dailyLogs);

  Set<String> get permittedExpertNames => Set.unmodifiable(_permittedExpertNames);

  bool hasExpertPermission(String expertName) {
    return _permittedExpertNames.contains(expertName);
  }

  void addOrUpdateDailyLog(DailyLogEntry entry) {
    final normalized = DateTime(entry.date.year, entry.date.month, entry.date.day);
    final updated = DailyLogEntry(
      date: normalized,
      periodFlow: entry.periodFlow,
      ovulationTest: entry.ovulationTest,
      symptoms: entry.symptoms,
      otherSymptoms: entry.otherSymptoms,
      mood: entry.mood,
      sleep: entry.sleep,
      weight: entry.weight,
    );

    final index = _dailyLogs.indexWhere(
      (item) =>
          item.date.year == normalized.year &&
          item.date.month == normalized.month &&
          item.date.day == normalized.day,
    );

    if (index != -1) {
      _dailyLogs[index] = updated;
    } else {
      _dailyLogs.insert(0, updated);
    }

    _dailyLogs.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void setPermittedExperts(Set<String> expertNames) {
    _permittedExpertNames
      ..clear()
      ..addAll(expertNames);
    notifyListeners();
  }

  String buildMedicalReportText({
    required Map<String, dynamic> profileData,
  }) {
    final String email = (profileData['email'] ?? 'N/A').toString();
    final String role = (profileData['role'] ?? 'Patient').toString();
    final String age = (profileData['age'] ?? 'N/A').toString();
    final String firstDay = (profileData['first_day_of_period'] ?? 'N/A').toString();
    final String cycleLength = (profileData['cycle_length'] ?? 'N/A').toString();
    final String periodDuration = (profileData['period_duration'] ?? 'N/A').toString();
    final String otherIssues = (profileData['other_issues'] ?? '').toString().trim();

    final List<String> flatSymptoms = [];
    final rawFlat = profileData['selected_symptoms'];
    if (rawFlat is List) {
      flatSymptoms.addAll(rawFlat.map((e) => e.toString()));
    }

    final Map<String, List<String>> categorized = {};
    final rawCat = profileData['categorized_symptoms'];
    if (rawCat is Map) {
      rawCat.forEach((key, value) {
        if (value is List) {
          categorized[key.toString()] = value.map((e) => e.toString()).toList();
        }
      });
    }

    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('FERTIDX 360 - COMPLETE MEDICAL REPORT');
    buffer.writeln('Generated On: ${DateTime.now().toIso8601String()}');
    buffer.writeln('========================================');
    buffer.writeln();
    buffer.writeln('1. PATIENT & INITIAL SETUP PROFILE');
    buffer.writeln('- Email: $email');
    buffer.writeln('- Role: $role');
    buffer.writeln('- Age: $age');
    buffer.writeln('- Last Period Start Date: $firstDay');
    buffer.writeln('- Average Cycle Length: $cycleLength days');
    buffer.writeln('- Average Period Duration: $periodDuration days');
    buffer.writeln(
      '- Other Issues / Notes: ${otherIssues.isEmpty ? 'None' : otherIssues}',
    );
    buffer.writeln();

    buffer.writeln('2. INITIAL ONBOARDING SYMPTOMS');
    final bool hasCat = categorized.values.any((list) => list.isNotEmpty);
    if (hasCat) {
      categorized.forEach((category, items) {
        buffer.writeln(
          '- $category: ${items.isEmpty ? 'None' : items.join(', ')}',
        );
      });
    } else if (flatSymptoms.isNotEmpty) {
      buffer.writeln('- Selected Symptoms: ${flatSymptoms.join(', ')}');
    } else {
      buffer.writeln('- Selected Symptoms: None');
    }
    buffer.writeln();

    buffer.writeln('3. DAILY LOG HISTORY (${_dailyLogs.length} entries)');
    if (_dailyLogs.isEmpty) {
      buffer.writeln('- No daily logs recorded yet.');
    } else {
      for (final log in _dailyLogs) {
        final dateStr =
            '${log.date.day.toString().padLeft(2, '0')}-${log.date.month.toString().padLeft(2, '0')}-${log.date.year}';
        buffer.writeln('Date: $dateStr');
        buffer.writeln('  * Period Flow: ${log.periodFlow ?? 'None'}');
        buffer.writeln(
          '  * Ovulation Test: ${log.ovulationTest ? 'Positive' : 'Negative / Not Logged'}',
        );
        buffer.writeln(
          '  * Symptoms: ${log.symptoms.isEmpty ? 'None' : log.symptoms.join(', ')}',
        );
        if (log.otherSymptoms.isNotEmpty) {
          buffer.writeln('  * Other Symptoms / Notes: ${log.otherSymptoms}');
        }
        buffer.writeln('  * Mood: ${log.mood ?? 'Not Logged'}');
        buffer.writeln(
          '  * Sleep: ${log.sleep.isEmpty ? 'Not Logged' : '${log.sleep} hrs'}',
        );
        buffer.writeln(
          '  * Weight: ${log.weight.isEmpty ? 'Not Logged' : log.weight}',
        );
      }
    }
    buffer.writeln();

    buffer.writeln('4. SHARED / PERMITTED EXPERTS');
    if (_permittedExpertNames.isEmpty) {
      buffer.writeln('- None selected');
    } else {
      buffer.writeln('- Permitted Experts: ${_permittedExpertNames.join(', ')}');
    }
    buffer.writeln('========================================');

    return buffer.toString();
  }

  Future<bool> downloadReport({
    required String fileName,
    required String reportContent,
  }) {
    return triggerReportDownload(
      fileName: fileName,
      content: reportContent,
    );
  }
}

class MedicalReportProvider extends InheritedNotifier<MedicalReportService> {
  const MedicalReportProvider({
    super.key,
    required MedicalReportService service,
    required super.child,
  }) : super(notifier: service);

  static MedicalReportService of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MedicalReportProvider>();
    assert(provider != null, 'MedicalReportProvider not found in widget tree');
    return provider!.notifier!;
  }
}