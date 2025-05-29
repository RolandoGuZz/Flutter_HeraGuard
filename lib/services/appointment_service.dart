import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/functions/functions.dart';

class AppointmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static int _contNoti = 0;

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('appointments')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  static Future<Map<String, dynamic>> getAppointment({
    required String idAppointment,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("Usuario no autenticado");

    final appointment =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('appointments')
            .doc(idAppointment)
            .get();

    if (!appointment.exists) {
      throw Exception("Cita no encontrada");
    }
    return appointment.data() as Map<String, dynamic>;
  }

  static Future<void> addAppointment({
    required String date,
    required String time,
    required String? doctor,
    required String address,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');
    int idNoti = _contNoti++;
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .add({
          'idNoti': idNoti,
          'date': date,
          'time': time,
          'doctor': doctor,
          'address': address,
        });

    await Functions.programarNotificacionesDeCitas();
  }

  static Future<void> deleteAppointment({required String idAppointment}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .doc(idAppointment)
        .delete();
  }

  static Future<void> updateAppointment({
    required String idAppointment,
    required Map<String, dynamic> data,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .doc(idAppointment)
        .update(data);
  }
}
