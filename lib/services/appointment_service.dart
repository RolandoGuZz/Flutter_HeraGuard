import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> getAppointments() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return [];

  final uid = currentUser.uid;
  final appointmentsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('appointments');

  final snapshot = await appointmentsRef.get();

  return snapshot.docs.map((doc) => doc.data()).toList();
}
