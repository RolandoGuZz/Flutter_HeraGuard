// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:intl/intl.dart';

class Functions {
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

  static Future<void> guardarCita({
    required BuildContext context,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController doctorController,
    required TextEditingController addressController,
  }) async {
    await AppointmentService.addAppointment(
      date: dateController.text,
      time: timeController.text,
      doctor: doctorController.text,
      address: addressController.text,
    );
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

  static Future<void> actualizarCita({
    required BuildContext context,
    required String idAppointment,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController doctorController,
    required TextEditingController addressController,
  }) async {
    final updateData = {
      'date': dateController.text,
      'time': timeController.text,
      'doctor': doctorController.text,
      'address': addressController.text,
    };
    await AppointmentService.updateAppointment(
      idAppointment: idAppointment,
      data: updateData,
    );
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
  }

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
    await MedicineService.addMedicine(
      route: routeValue,
      name: nameController.text,
      dose: doseController.text,
      frequency: frequencyValue,
      specificTime: specificTimeController.text,
      duration: durationValue,
      durationNumber: durationController.text,
      startDate: startDateController.text,
    );
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
    final updateData = {
      'route': routeValue,
      'name': nameController.text,
      'dose': doseController.text,
      'frequency': frequencyValue,
      'specificTime': specificTimeController.text,
      'duration': durationValue,
      'durationNumber': durationController.text,
      'startDate': startDateController.text,
    };
    await MedicineService.updateMedicine(
      idMedicine: idMedicine,
      data: updateData,
    );
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
  }
}
