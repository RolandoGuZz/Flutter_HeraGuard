import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Mexico_City'));
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings),
    );
  }

  static Future<void> requestPermissions() async {
    final androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  static Future<void> showImmediateNotification({
    required String title,
    required String body,
    required int id,
  }) async {
    const AndroidNotificationDetails
    androidDetails = AndroidNotificationDetails(
      'immediate_channel', //id canal para organizar
      'Notificaciones Inmediatas', // nombre del canal que aparece en ajustes de noti
      channelDescription:
          'Notificaciones que se muestran inmediatamente', //descripcion del canal
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> scheduleNotificationExact({
    required String title,
    required String body,
    required DateTime dateTime,
    required int id,
  }) async {
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_channel',
          'Recordatorios Programados',
          channelDescription: 'Notificaciones programadas para recordatorios',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: null,
    );
  }
}
