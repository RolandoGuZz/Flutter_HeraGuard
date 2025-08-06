// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heraguard/models/appointment_model.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class AppointmentController extends ChangeNotifier {
  List<Appointment> _citas = [];
  bool _cargando = false;
  String? _error;

  List<Appointment> get citas => _citas;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> loadAppointments() async {
    try {
      _cargando = true;
      notifyListeners();

      _citas = await AppointmentService.getAppointments();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar citas: ${e.toString()}';
      _citas = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> saveAppointment({
    required BuildContext context,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController doctorController,
    required TextEditingController addressController,
  }) async {
    try {
      _cargando = true;
      notifyListeners();

      final nuevaCita = Appointment(
        idNoti: 0,
        date: dateController.text,
        time: timeController.text,
        doctor: doctorController.text.isNotEmpty ? doctorController.text : null,
        address: addressController.text,
      );

      await AppointmentService.addAppointment(nuevaCita);
      await loadAppointments();
      await scheduleAppointmentNotifications();

      _mostrarSnackbar(context, 'Cita guardada con éxito', esExito: true);
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarSnackbar(context, 'Error al guardar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> updateAppointment({
    required BuildContext context,
    required String idAppointment,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController doctorController,
    required TextEditingController addressController,
  }) async {
    try {
      _cargando = true;
      notifyListeners();

      final citaExistente = await AppointmentService.getAppointment(
        idAppointment: idAppointment,
      );

      final citaActualizada = citaExistente.copyWith(
        date: dateController.text,
        time: timeController.text,
        doctor: doctorController.text.isNotEmpty ? doctorController.text : null,
        address: addressController.text,
      );

      await AppointmentService.updateAppointment(citaActualizada);
      await loadAppointments();
      print('✅ Noti de cita actu programada');
      await scheduleAppointmentNotifications();

      _mostrarSnackbar(context, 'Cita actualizada con éxito', esExito: true);
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarSnackbar(context, 'Error al actualizar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> deleteAppointment({
    required BuildContext context,
    required String idAppointment,
  }) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => _buildDialogoConfirmacion(context),
      );

      if (confirm == true) {
        _cargando = true;
        notifyListeners();

        // Obtener cita para el ID de notificación
        final cita = await AppointmentService.getAppointment(
          idAppointment: idAppointment,
        );

        await FlutterLocalNotificationsPlugin().cancel(cita.idNoti);
        await AppointmentService.deleteAppointment(
          idAppointment: idAppointment,
        );
        await loadAppointments();

        _mostrarSnackbar(context, 'Cita eliminada con éxito', esExito: true);
      }
    } catch (e) {
      _mostrarSnackbar(context, 'Error al eliminar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> scheduleAppointmentNotifications() async {
    try {
      for (final cita in _citas) {
        try {
          final now = tz.TZDateTime.now(tz.local);
          final fechaHora = DateFormat(
            'dd/MM/yyyy h:mm a',
          ).parse(cita.fullDateTime);
          final fechaHoraTZ = tz.TZDateTime.from(fechaHora, tz.local);

          if (!fechaHoraTZ.isAfter(now)) continue;

          await NotificationService.scheduleNotificationExact(
            id: cita.idNoti,
            title: 'Tienes cita médica con ${cita.doctor ?? 'Médico'}',
            body: 'Lugar: ${cita.address} a las ${cita.time}',
            dateTime: fechaHora,
          );
        } catch (e) {
          print('Error programando notificación para cita ${cita.id}: $e');
        }
      }
    } catch (e) {
      print('Error al programar notificaciones: $e');
    }
  }

  // Métodos auxiliares
  
  Widget _buildDialogoConfirmacion(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Eliminar cita?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Color.fromRGBO(35, 150, 230, 1)),
          ),
        ),
      ],
    );
  }

  void _mostrarSnackbar(
    BuildContext context,
    String mensaje, {
    bool esExito = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            esExito ? const Color.fromRGBO(35, 150, 230, 1) : Colors.red,
        //behavior: SnackBarBehavior.floating, // Opcional: estilo flotante
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ), // Opcional: bordes redondeados
        ),
      ),
    );
  }
}
