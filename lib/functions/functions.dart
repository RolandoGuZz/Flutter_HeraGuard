// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:heraguard/services/appointment_service.dart';
// import 'package:heraguard/services/medicine_service.dart';
// import 'package:heraguard/services/notification_service.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:heraguard/models/appointment_model.dart';

/// Clase que centraliza las funciones a utilizar en la aplicación.
/// Proporciona métodos estáticos para operaciones comunes que pueden ser invocados desde cualquier parte del código.
/// Dependencias:
/// - flutter_local_notifications: Para gestión de notificaciones locales
/// - intl: Para formato de fechas y horas
/// - timezone: Para manejo de zonas horarias en notificaciones
/// - appointment_service.dart: Servicio de operaciones con citas
/// - medicine_service.dart: Servicio de operaciones con medicamentos
/// - notification_service.dart: Servicio de gestión de notificaciones

//!Documentar cada funcion pero hay que ver si se separa, si no dejarlo asi
class Functions {
  //static final int _idNoti = 0;
  //static int _idNotiMedi = 0;

  static Future<void> showCalendar({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  static Future<void> showTime({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

  //   static Future<void> programarNotificacionesDeCitas() async {
  //     try {
  //       final List<Appointment> citas =
  //           await AppointmentService.getAppointments();

  //       for (final cita in citas) {
  //         try {
  //           final doctor = cita.hasDoctor ? cita.doctor! : 'Médico';
  //           final direccion =
  //               cita.address.isNotEmpty ? cita.address : 'Dirección desconocida';

  //           final DateFormat formato = DateFormat('dd/MM/yyyy h:mm a');
  //           final DateTime fechaHora = formato.parse(cita.fullDateTime);
  //           final tz.TZDateTime fechaHoraTZ = tz.TZDateTime.from(
  //             fechaHora,
  //             tz.local,
  //           );
  //           final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  //           print(
  //             'Programando noti ID ${cita.idNoti} para $fechaHoraTZ (ahora: $now)',
  //           );

  //           if (!fechaHoraTZ.isAfter(now)) {
  //             print(
  //               '❌ No se programó la notificación ID ${cita.idNoti} porque la fecha ya pasó',
  //             );
  //             continue;
  //           }

  //           await NotificationService.scheduleNotificationExact(
  //             id: cita.idNoti,
  //             title: 'Tienes cita médica con $doctor',
  //             body: 'Lugar: $direccion, Hora ${cita.time}',
  //             dateTime: fechaHora,
  //           );

  //           print('✅ Notificación ID ${cita.idNoti} programada correctamente');
  //         } catch (e) {
  //           print('❌ Error al programar notificación ID ${cita.idNoti}: $e');
  //         }
  //       }
  //     } catch (e) {
  //       print('❌ Error al obtener citas: $e');
  //     }
  //   }

  //   static Future<void> programarNotificacionesDeMedicamentos() async {
  //     final medicamentos = await MedicineService.getMedications();

  //     for (var medicamento in medicamentos) {
  //       final String nombre = medicamento.name;
  //       final String dosis = medicamento.dose;
  //       final String horaStr = medicamento.specificTime ?? '';
  //       _idNotiMedi = (medicamento.idNotiM);

  //       try {
  //         final now = DateTime.now();
  //         final horaFormat = DateFormat('h:mm a');
  //         final horaMedicamento = horaFormat.parse(horaStr);
  //         final fechaNotificacion = DateTime(
  //           now.year,
  //           now.month,
  //           now.day,
  //           horaMedicamento.hour,
  //           horaMedicamento.minute,
  //         );

  //         print('Programando noti ID $_idNotiMedi para $fechaNotificacion');
  //         if (!fechaNotificacion.isAfter(now)) {
  //           print('❌ Hora ya pasó hoy para $nombre');
  //           continue;
  //         }
  //         await NotificationService.scheduleNotificationExact(
  //           id: _idNotiMedi,
  //           title: 'Hora de tomar $nombre',
  //           body: 'Dosis: $dosis',
  //           dateTime: fechaNotificacion,
  //         );
  //         print('✅ Notificación para $nombre programada');
  //       } catch (e) {
  //         print('❌ Error con medicamento ID $_idNotiMedi: $e');
  //       }
  //     }
  //   }
}
