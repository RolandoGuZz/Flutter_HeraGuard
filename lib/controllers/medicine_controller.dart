// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heraguard/models/medicine_model.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:heraguard/services/notification_service.dart';
import 'package:intl/intl.dart';

class MedicineController extends ChangeNotifier {
  List<Medicine> _medicamentos = [];
  bool _cargando = false;
  String? _error;

  List<Medicine> get medicamentos => _medicamentos;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> loadMedicines() async {
    try {
      _cargando = true;
      notifyListeners();

      _medicamentos = await MedicineService.getMedications();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar medicamentos: ${e.toString()}';
      _medicamentos = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> saveMedicine({
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
      _cargando = true;
      notifyListeners();

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

      await MedicineService.addMedicine(nuevoMedicamento);
      await loadMedicines();
      await _programarNotificaciones();

      _mostrarSnackbar(context, 'Medicamento guardado con éxito', esExito: true);
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarSnackbar(context, 'Error al guardar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> updateMedicine({
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
      _cargando = true;
      notifyListeners();

      final medicamentoExistente = await MedicineService.getMedicine(
        idMedicine: idMedicine,
      );

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

      await MedicineService.updateMedicine(medicamentoActualizado);
      await loadMedicines();
      print('✅ Noti de medi actu programada');
      await _programarNotificaciones();

      _mostrarSnackbar(
          context, 'Medicamento actualizado con éxito', esExito: true);
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarSnackbar(context, 'Error al actualizar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedicine({
    required BuildContext context,
    required String idMedicine,
    required int idNoti,
  }) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => _buildDialogoConfirmacion(context),
      );

      if (confirm == true) {
        _cargando = true;
        notifyListeners();

        await FlutterLocalNotificationsPlugin().cancel(idNoti);
        await MedicineService.deleteMedicine(idMedicine: idMedicine);
        await loadMedicines();

        _mostrarSnackbar(context, 'Medicamento eliminado con éxito', esExito: true);
      }
    } catch (e) {
      _mostrarSnackbar(context, 'Error al eliminar: ${e.toString()}');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> _programarNotificaciones() async {
    try {
      for (final medicamento in _medicamentos) {
        try {
          final horaStr = medicamento.specificTime ?? '';
          if (horaStr.isEmpty) continue;

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

          if (!fechaNotificacion.isAfter(now)) continue;

          await NotificationService.scheduleNotificationExact(
            id: medicamento.idNotiM,
            title: 'Hora de tomar ${medicamento.name}',
            body: 'Dosis: ${medicamento.dose}',
            dateTime: fechaNotificacion,
          );
        } catch (e) {
          print('Error programando notificación para ${medicamento.name}: $e');
        }
      }
    } catch (e) {
      print('Error al programar notificaciones: $e');
    }
  }

  // Métodos auxiliares
  Widget _buildDialogoConfirmacion(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Eliminar medicamento?'),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}