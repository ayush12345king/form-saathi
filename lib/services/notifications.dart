import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/doc_item.dart';

/// Phone notifications before a document expires: 30, 7 and 1 day before,
/// at 9 AM. Everything happens on the phone; no server or internet needed.
class ExpiryNotifications {
  ExpiryNotifications._();
  static final ExpiryNotifications instance = ExpiryNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _daysBefore = [30, 7, 1];
  static const _channel = AndroidNotificationDetails(
    'expiry_reminders',
    'Expiry reminders',
    channelDescription: 'Reminders before your documents expire',
    importance: Importance.high,
    priority: Priority.high,
  );

  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      // The app is made for India, so reminders use Indian time.
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      await _plugin.initialize(
        const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      );
      _ready = true;
    } catch (e) {
      debugPrint('Notifications not available: $e');
    }
  }

  /// Asks for permission (Android 13+ shows a popup once).
  Future<void> requestPermission() async {
    if (!_ready) return;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  /// Clears old reminders and schedules fresh ones for every document.
  Future<void> rescheduleAll(List<DocItem> docs, {required bool hindi}) async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      final now = tz.TZDateTime.now(tz.local);
      var id = 0;
      for (final doc in docs) {
        for (final days in _daysBefore) {
          final day = doc.expiry.subtract(Duration(days: days));
          final when = tz.TZDateTime(tz.local, day.year, day.month, day.day, 9);
          if (!when.isAfter(now)) continue;
          id++;
          final name = docTypeName(doc.type) + (doc.label.isEmpty ? '' : ' (${doc.label})');
          final title = hindi ? '$name $days दिन में खत्म होगा' : '$name expires in $days day${days == 1 ? '' : 's'}';
          final body = hindi
              ? 'समाप्ति: ${formatDate(doc.expiry)}। अभी रिन्यू करें ताकि आखिरी समय की भागदौड़ न हो।'
              : 'Expiry: ${formatDate(doc.expiry)}. Renew now to avoid a last-minute rush.';
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            when,
            const NotificationDetails(android: _channel),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    } catch (e) {
      debugPrint('Could not schedule reminders: $e');
    }
  }
}
