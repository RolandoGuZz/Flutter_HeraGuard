import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicineService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<List<Map<String, dynamic>>> getMedications() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('medications')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  static Future<void> addMedicine({
    required String? route,
    required String name,
    required String dose,
    required String? frequency,
    required String? specificTime,
    required String? duration,
    required String durationNumber,
    required String startDate,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('medications')
        .add({
          'route': route,
          'name': name,
          'dose': dose,
          'frequency': frequency,
          'specificTime': specificTime,
          'duration': duration,
          'durationNumber': durationNumber,
          'startDate': startDate,
        });
  }

  static Future<Map<String, dynamic>> getMedicine({
    required String idMedicine,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("Usuario no autenticado");

    final appointment =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('medications')
            .doc(idMedicine)
            .get();

    if (!appointment.exists) {
      throw Exception("Medicamento no encontrado");
    }
    return appointment.data() as Map<String, dynamic>;
  }

  static Future<void> deleteMedicine({required String idMedicine}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('medications')
        .doc(idMedicine)
        .delete();
  }

  static Future<void> updateMedicine({
    required String idMedicine,
    required Map<String, dynamic> data,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('medications')
        .doc(idMedicine)
        .update(data);
  }
}
