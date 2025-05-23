// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:heraguard/services/appointment_service.dart';
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

  static Future<void> guardarTratamiento({
    required BuildContext context,
    required String? dropOption,
    required TextEditingController nameController,
    required TextEditingController doseController,
    required TextEditingController frequencyController,
    required TextEditingController specificTimeController,
    required TextEditingController durationController,
    required TextEditingController routeController,
  }) async {
    await AppointmentService.addTreatment(
      type: dropOption,
      name: nameController.text,
      dose: doseController.text,
      frequency: frequencyController.text,
      specificTime: specificTimeController.text,
      duration: durationController.text,
      routeOfAdministration: routeController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tratamiento guardado con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    Navigator.pop(context);
  }

  // static Future<void> loginUser({
  //   required GlobalKey<FormState> formKey,
  //   required BuildContext context,
  //   required bool isLoading,
  //   required TextEditingController emailController,
  //   required TextEditingController passwordController,

  // }) async {
  //   if (!formKey.currentState!.validate()) return;
  //   setState(() => isLoading = true);
  //   try {
  //     final userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim(),
  //         );
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Bienvenido ${userCredential.user!.email}',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 18,
  //           ),
  //         ),
  //         backgroundColor: Color.fromRGBO(35, 150, 230, 1),
  //       ),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => HomeScreen()),
  //     );
  //   } on FirebaseAuthException catch (error) {
  //     String errorMessage = 'Error al iniciar sesión';
  //     if (error.code == 'invalid-email') {
  //       errorMessage = 'Correo inválido';
  //     } else if (error.code == 'invalid-credential') {
  //       errorMessage = 'Correo o contraseña incorrectas';
  //     }
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }
}
