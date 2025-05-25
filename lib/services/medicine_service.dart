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

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> addMedicine({
    required String? type,
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
          'type': type,
          'name': name,
          'dose': dose,
          'frequency': frequency,
          'specificTime': specificTime,
          'duration': duration,
          'durationNumber': durationNumber,
          'startDate': startDate,
        });
  }
}
