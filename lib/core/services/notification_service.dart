import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String expertName;
  final String specialization;
  final DateTime appointmentDate;
  final String appointmentTime;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.expertName,
    required this.specialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.createdAt,
    this.isRead = false,
  });
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addAppointmentNotification({
    required String expertName,
    required String specialization,
    required DateTime date,
    required String time,
  }) {
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    final notification = AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: 'Appointment Booked',
      message:
          'Your appointment with $expertName ($specialization) is confirmed for $formattedDate at $time.',
      expertName: expertName,
      specialization: specialization,
      appointmentDate: date,
      appointmentTime: time,
      createdAt: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAllAsRead() {
    bool changed = false;
    for (final item in _notifications) {
      if (!item.isRead) {
        item.isRead = true;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }
}

class NotificationProvider extends InheritedNotifier<NotificationService> {
  const NotificationProvider({
    super.key,
    required NotificationService service,
    required super.child,
  }) : super(notifier: service);

  static NotificationService of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<NotificationProvider>();
    assert(provider != null, 'NotificationProvider not found in widget tree');
    return provider!.notifier!;
  }
}