// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heraguard/models/medicine_model.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:heraguard/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:heraguard/models/appointment_model.dart';

/// Clase que centraliza las funciones a utilizar en la aplicación.
/// Proporciona métodos estáticos para operaciones comunes que pueden ser invocados desde cualquier parte del código.
/// Dependencias:
/// - flutter_local_notifications: Para gestión de notificaciones locales
/// - intl: Para formato de fechas y horas
/// - timezone: Para manejo de zonas horarias en notificaciones
/// - appointment_service.dart: Servicio de operaciones con citas
/// - medicine_service.dart: Servicio de operaciones con medicamentos
/// - notification_service.dart: Servicio de gestión de notificaciones


//!Documenrar cada funciono pero hay que ver si se separa, si no dejarlo asi
class Functions {
  static int _idNoti = 0;
  static int _idNotiMedi = 0;

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

  // static Future<void> guardarCita({
  //   required BuildContext context,
  //   required TextEditingController dateController,
  //   required TextEditingController timeController,
  //   required TextEditingController doctorController,
  //   required TextEditingController addressController,
  // }) async {
  //   await AppointmentService.addAppointment(
  //     date: dateController.text,
  //     time: timeController.text,
  //     doctor: doctorController.text,
  //     address: addressController.text,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Cita guardada con éxito',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Color.fromRGBO(35, 150, 230, 1),
  //     ),
  //   );
  //   Navigator.pop(context, true);
  // }

  static Future<void> guardarCita({
  required BuildContext context,
  required TextEditingController dateController,
  required TextEditingController timeController,
  required TextEditingController doctorController,
  required TextEditingController addressController,
}) async {
  // Creamos el objeto Appointment con los datos del formulario
  final nuevaCita = Appointment(
    idNoti: 0, // El servicio asignará el valor correcto
    date: dateController.text,
    time: timeController.text,
    doctor: doctorController.text.isNotEmpty ? doctorController.text : null,
    address: addressController.text,
  );

  try {
    // Pasamos el objeto al servicio
    await AppointmentService.addAppointment(nuevaCita);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cita guardada con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error al guardar la cita: ${e.toString()}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  static Future<void> eliminarCita({
    required BuildContext context,
    required String idAppointment,
  }) async {
    try {
      bool confirm = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('¿Eliminar cita?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Color.fromRGBO(35, 150, 230, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      );
      if (confirm == true) {
        print('Eliminando noti ID $_idNoti');
        await FlutterLocalNotificationsPlugin().cancel(_idNoti);
        await AppointmentService.deleteAppointment(
          idAppointment: idAppointment,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cita eliminada con éxito',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color.fromRGBO(35, 150, 230, 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar la cita',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // static Future<void> actualizarCita({
  //   required BuildContext context,
  //   required String idAppointment,
  //   required TextEditingController dateController,
  //   required TextEditingController timeController,
  //   required TextEditingController doctorController,
  //   required TextEditingController addressController,
  // }) async {
  //   final updateData = {
  //     'date': dateController.text,
  //     'time': timeController.text,
  //     'doctor': doctorController.text,
  //     'address': addressController.text,
  //   };
  //   await AppointmentService.updateAppointment(
  //     idAppointment: idAppointment,
  //     data: updateData,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Cita actualizada con éxito',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Color.fromRGBO(35, 150, 230, 1),
  //     ),
  //   );
  //   Navigator.pop(context, true);
  // }

  static Future<void> actualizarCita({
  required BuildContext context,
  required String idAppointment,
  required TextEditingController dateController,
  required TextEditingController timeController,
  required TextEditingController doctorController,
  required TextEditingController addressController,
}) async {
  try {
    // Primero obtenemos la cita existente para preservar el idNoti
    final citaExistente = await AppointmentService.getAppointment(
      idAppointment: idAppointment,
    );

    // Creamos el objeto Appointment con los datos actualizados
    final citaActualizada = citaExistente.copyWith(
      date: dateController.text,
      time: timeController.text,
      doctor: doctorController.text.isNotEmpty ? doctorController.text : null,
      address: addressController.text,
    );

    // Enviamos la cita actualizada al servicio
    await AppointmentService.updateAppointment(citaActualizada);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cita actualizada con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error al actualizar la cita: ${e.toString()}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // static Future<void> guardarMedicamento({
  //   required BuildContext context,
  //   required String? routeValue,
  //   required TextEditingController nameController,
  //   required TextEditingController doseController,
  //   required String? frequencyValue,
  //   required TextEditingController specificTimeController,
  //   required String? durationValue,
  //   required TextEditingController durationController,
  //   required TextEditingController startDateController,
  // }) async {
  //   await MedicineService.addMedicine(
  //     route: routeValue,
  //     name: nameController.text,
  //     dose: doseController.text,
  //     frequency: frequencyValue,
  //     specificTime: specificTimeController.text,
  //     duration: durationValue,
  //     durationNumber: durationController.text,
  //     startDate: startDateController.text,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Medicamento guardado con éxito',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Color.fromRGBO(35, 150, 230, 1),
  //     ),
  //   );
  //   Navigator.pop(context, true);
  // }

  static Future<void> guardarMedicamento({
  required BuildContext context,
  required String? routeValue,
  required TextEditingController nameController,
  required TextEditingController doseController,
  required String? frequencyValue,
  required TextEditingController specificTimeController,
  required String? durationValue,
  required TextEditingController durationController,
  required TextEditingController startDateController,
}) async {
  try {
    // Creamos el objeto Medicamento con los datos del formulario
    final nuevoMedicamento = Medicine(
      idNotiM: 0, // El servicio asignará el ID correcto
      route: routeValue,
      name: nameController.text,
      dose: doseController.text,
      frequency: frequencyValue,
      specificTime: specificTimeController.text.isNotEmpty 
          ? specificTimeController.text 
          : null,
      duration: durationValue,
      durationNumber: durationController.text,
      startDate: startDateController.text,
    );

    // Pasamos el objeto al servicio
    await MedicineService.addMedicine(nuevoMedicamento);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Medicamento guardado con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error al guardar medicamento: ${e.toString()}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  static Future<void> eliminarMedicamento({
    required BuildContext context,
    required String idMedicine,
  }) async {
    try {
      bool confirm = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('¿Eliminar medicamento?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Color.fromRGBO(35, 150, 230, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      );
      if (confirm == true) {
        print('Eliminando noti de medi con id $_idNotiMedi');
        await FlutterLocalNotificationsPlugin().cancel(_idNotiMedi);
        await MedicineService.deleteMedicine(idMedicine: idMedicine);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Medicamento eliminado con éxito',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color.fromRGBO(35, 150, 230, 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el medicamento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // static Future<void> actualizarMedicamento({
  //   required BuildContext context,
  //   required String idMedicine,
  //   required String? routeValue,
  //   required TextEditingController nameController,
  //   required TextEditingController doseController,
  //   required String? frequencyValue,
  //   required TextEditingController specificTimeController,
  //   required String? durationValue,
  //   required TextEditingController durationController,
  //   required TextEditingController startDateController,
  // }) async {
  //   final updateData = {
  //     'route': routeValue,
  //     'name': nameController.text,
  //     'dose': doseController.text,
  //     'frequency': frequencyValue,
  //     'specificTime': specificTimeController.text,
  //     'duration': durationValue,
  //     'durationNumber': durationController.text,
  //     'startDate': startDateController.text,
  //   };
  //   await MedicineService.updateMedicine(
  //     idMedicine: idMedicine,
  //     data: updateData,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Medicamento actualizado con éxito',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Color.fromRGBO(35, 150, 230, 1),
  //     ),
  //   );
  //   Navigator.pop(context, true);
  // }

  static Future<void> actualizarMedicamento({
  required BuildContext context,
  required String idMedicine,
  required String? routeValue,
  required TextEditingController nameController,
  required TextEditingController doseController,
  required String? frequencyValue,
  required TextEditingController specificTimeController,
  required String? durationValue,
  required TextEditingController durationController,
  required TextEditingController startDateController,
}) async {
  try {
    // Primero obtenemos el medicamento existente para preservar el idNotiM
    final medicamentoExistente = await MedicineService.getMedicine(
      idMedicine: idMedicine,
    );

    // Creamos el objeto Medicamento con los datos actualizados
    final medicamentoActualizado = medicamentoExistente.copyWith(
      route: routeValue,
      name: nameController.text,
      dose: doseController.text,
      frequency: frequencyValue,
      specificTime: specificTimeController.text.isNotEmpty 
          ? specificTimeController.text 
          : null,
      duration: durationValue,
      durationNumber: durationController.text,
      startDate: startDateController.text,
    );

    // Enviamos el medicamento actualizado al servicio
    await MedicineService.updateMedicine(medicamentoActualizado);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Medicamento actualizado con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error al actualizar medicamento: ${e.toString()}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // static Future<void> programarNotificacionesDeCitas() async {
  //   final citas = await AppointmentService.getAppointments();

  //   for (var cita in citas) {
  //     final String fechaStr = cita['date'];
  //     final String horaStr = cita['time'];
  //     final String doctor =
  //         (cita['doctor'] ?? '').isEmpty ? 'Médico' : cita['doctor'];
  //     final String direccion = cita['address'] ?? 'Dirección desconocida';
  //     _idNoti = cita['idNoti'];
  //     try {
  //       final DateFormat formato = DateFormat('dd/MM/yyyy h:mm a');
  //       final DateTime fechaHora = formato.parse('$fechaStr $horaStr');
  //       final tz.TZDateTime fechaHoraTZ = tz.TZDateTime.from(
  //         fechaHora,
  //         tz.local,
  //       );
  //       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //       print('Programando noti ID $_idNoti para $fechaHoraTZ (ahora: $now)');
  //       if (!fechaHoraTZ.isAfter(now)) {
  //         print(
  //           '❌ No se programó la notificación ID $_idNoti porque la fecha ya pasó',
  //         );
  //         continue;
  //       }
  //       await NotificationService.scheduleNotificationExact(
  //         id: _idNoti,
  //         title: 'Tienes cita médica con $doctor',
  //         body: 'Lugar: $direccion, Hora $horaStr',
  //         dateTime: fechaHora,
  //       );
  //       print('✅ Notificación ID $_idNoti programada correctamente');
  //     } catch (e) {
  //       print('❌ Error al programar notificación ID $_idNoti: $e');
  //     }
  //   }
  // }

  static Future<void> programarNotificacionesDeCitas() async {
  try {
    final List<Appointment> citas = await AppointmentService.getAppointments();

    for (final cita in citas) {
      try {
        final doctor = cita.hasDoctor ? cita.doctor! : 'Médico';
        final direccion = cita.address.isNotEmpty ? cita.address : 'Dirección desconocida';
        
        final DateFormat formato = DateFormat('dd/MM/yyyy h:mm a');
        final DateTime fechaHora = formato.parse(cita.fullDateTime);
        final tz.TZDateTime fechaHoraTZ = tz.TZDateTime.from(fechaHora, tz.local);
        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

        print('Programando noti ID ${cita.idNoti} para $fechaHoraTZ (ahora: $now)');
        
        if (!fechaHoraTZ.isAfter(now)) {
          print('❌ No se programó la notificación ID ${cita.idNoti} porque la fecha ya pasó');
          continue;
        }

        await NotificationService.scheduleNotificationExact(
          id: cita.idNoti,
          title: 'Tienes cita médica con $doctor',
          body: 'Lugar: $direccion, Hora ${cita.time}',
          dateTime: fechaHora,
        );
        
        print('✅ Notificación ID ${cita.idNoti} programada correctamente');
      } catch (e) {
        print('❌ Error al programar notificación ID ${cita.idNoti}: $e');
      }
    }
  } catch (e) {
    print('❌ Error al obtener citas: $e');
  }
}

  static Future<void> programarNotificacionesDeMedicamentos() async {
    final medicamentos = await MedicineService.getMedications();

    for (var medicamento in medicamentos) {
      final String nombre = medicamento.name;
      final String dosis = medicamento.dose;
      final String horaStr = medicamento.specificTime ?? '';
      _idNotiMedi = (medicamento.idNotiM);

      try {
        final now = DateTime.now();
        final horaFormat = DateFormat('h:mm a');
        final horaMedicamento = horaFormat.parse(horaStr);
        final fechaNotificacion = DateTime(
          now.year,
          now.month,
          now.day,
          horaMedicamento.hour,
          horaMedicamento.minute,
        );

        print('Programando noti ID $_idNotiMedi para $fechaNotificacion');
        if (!fechaNotificacion.isAfter(now)) {
          print('❌ Hora ya pasó hoy para $nombre');
          continue;
        }
        await NotificationService.scheduleNotificationExact(
          id: _idNotiMedi,
          title: 'Hora de tomar $nombre',
          body: 'Dosis: $dosis',
          dateTime: fechaNotificacion,
        );
        print('✅ Notificación para $nombre programada');
      } catch (e) {
        print('❌ Error con medicamento ID $_idNotiMedi: $e');
      }
    }
  }
}
