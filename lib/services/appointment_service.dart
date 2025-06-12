import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/functions/functions.dart';

// Servicio para gestionar citas médicas en Firestore.
/// Proporciona operaciones CRUD para las citas del usuario autenticado,
/// almacenadas en la subcolección 'appointments' del documento del usuario.

class AppointmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static int _contNoti = 0;

  /// Obtiene todas las citas del usuario actual.
  /// Características:
  /// - Retorna lista vacía si no hay usuario autenticado
  /// - Cada cita incluye sus datos + ID del documento
  ///
  /// Retorna:
  /// [List<Map<String, dynamic>>] donde cada mapa contiene:
  ///   - Campos de la cita (date, time, doctor, address)
  ///   - id: ID del documento en Firestore
  ///   - idNoti: ID de notificación asociada
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

  /// Obtiene una cita específica por su ID.
  /// Parámetros:
  /// - idAppointment: ID del documento de la cita
  /// 
  /// Lanza:
  /// Exception si:
  ///   - No hay usuario autenticado
  ///   - La cita no existe
  ///
  /// Retorna:
  /// - [Map<String, dynamic>] con los datos de la cita + ID del documento
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

   /// Agrega una nueva cita médica.
  /// Comportamiento:
  /// 1. Valida usuario autenticado
  /// 2. Genera ID de notificación único
  /// 3. Guarda en Firestore
  /// 4. Programa notificación local
  ///
  /// Parámetros:
  /// - date: Fecha en formato 'YYYY-MM-DD'
  /// - time: Hora en formato 'HH:MM'
  /// - doctor: Nombre del médico (opcional)
  /// - address: Dirección de la cita
  ///
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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

  /// Elimina una cita existente.
  /// Parámetros:
  /// - idAppointment: ID del documento a eliminar
  ///
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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

  /// Actualiza los datos de una cita existente.
  ///
  /// Parámetros:
  /// - idAppointment: ID del documento a actualizar
  /// - data: Mapa con campos a modificar
  /// 
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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
