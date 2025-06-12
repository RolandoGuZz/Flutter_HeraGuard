import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Servicio para manejar notificaciones locales en la aplicación.
/// Proporciona:
/// - Configuración inicial del sistema de notificaciones
/// - Solicitud de permisos
/// - Notificaciones inmediatas
/// - Notificaciones programadas con precisión temporal

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio de notificaciones.
  ///
  /// Configura:
  /// 1. Zona horaria (America/Mexico_City)
  /// 2. Icono de la aplicación para notificaciones (@mipmap/ic_launcher)
  ///
  /// Debe llamarse antes de cualquier otra función del servicio.
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Mexico_City'));
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings),
    );
  }

  /// Solicita permisos de notificación en Android.
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
  //!Checar esto para ver si se elimina el método
  /// Muestra una notificación inmediata.
  ///
  /// Parámetros:
  /// - title: Título principal de la notificación
  /// - body: Contenido descriptivo
  /// - id: ID único para manejar la notificación
  ///
  /// Características:
  /// - Canal: Notificaciones Inmediatas
  /// - Vibración activada
  /// - Sonido activado
  /// - Máxima prioridad
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

  /// Programa una notificación para una fecha/hora exacta.
  ///
  /// Parámetros:
  /// - title: Título de la notificación
  /// - body: Contenido descriptivo
  /// - dateTime: Fecha y hora exacta para mostrar (convertida a zona horaria local)
  /// - id: ID único para manejar la notificación
  ///
  /// Características:
  /// - Canal: Recordatorios Programados
  /// - Hora exacta (AndroidScheduleMode.exact)
  /// - Máxima prioridad
  /// - Usa la zona horaria configurada en initialize()
  static Future<void> scheduleNotificationExact({
    required String title,
    required String body,
    required DateTime dateTime,
    required int id,
  }) async {
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

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
