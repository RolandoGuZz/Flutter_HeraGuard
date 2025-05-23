import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('appointments')
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> addAppointment({
    required String date,
    required String time,
    required String doctor,
    required String address,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .add({
          'date': date,
          'time': time,
          'doctor': doctor,
          'address': address,
        });
  }

  static Future<void> addTreatment({
    required String? type,
    required String name,
    required String dose,
    required String frequency,
    required String? specificTime,
    required String duration,
    required String routeOfAdministration,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('treatment')
        .add({
          'type': type,
          'name': name,
          'dose': dose,
          'frequency': frequency,
          'specificTime': specificTime,
          'duration': duration,
          'routeOfAdministration': routeOfAdministration,
        });
  }
}
