import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/models/appointment_model.dart';

/// Servicio para gestionar citas médicas en Firestore utilizando modelos.
/// Proporciona operaciones CRUD para las citas del usuario autenticado,
/// almacenadas en la subcolección 'appointments' del documento del usuario.

class AppointmentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static int _contNoti = 0;

  /// Obtiene todas las citas del usuario actual como lista de objetos [Appointment].
  ///
  /// Características:
  /// - Retorna lista vacía si no hay usuario autenticado
  /// - Cada cita es un objeto [Appointment] con todos sus campos tipados
  /// - Incluye automáticamente el ID del documento de Firestore
  ///
  /// Retorna:
  /// [Future<List<Appointment>>] Lista de citas con todos sus datos estructurados
  static Future<List<Appointment>> getAppointments() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('appointments')
            .get();

    return snapshot.docs.map((doc) {
      return Appointment.fromMap(doc.data(), doc.id);
    }).toList();
  }

  /// Obtiene una cita específica por su ID como objeto [Appointment].
  ///
  /// Parámetros:
  /// - idAppointment: ID del documento de la cita en Firestore
  ///
  /// Lanza:
  /// [Exception] si:
  ///   - No hay usuario autenticado
  ///   - La cita no existe
  ///
  /// Retorna:
  /// [Future<Appointment>] Objeto completo de la cita con todos sus campos tipados
  static Future<Appointment> getAppointment({
    required String idAppointment,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("Usuario no autenticado");

    final doc =
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('appointments')
            .doc(idAppointment)
            .get();

    if (!doc.exists) throw Exception("Cita no encontrada");

    return Appointment.fromMap(doc.data()!, doc.id);
  }

  /// Agrega una nueva cita médica utilizando el modelo [Appointment].
  ///
  /// Comportamiento:
  /// 1. Valida usuario autenticado
  /// 2. Asigna ID de notificación único
  /// 3. Guarda en Firestore
  /// 4. Programa notificación local
  ///
  /// Parámetros:
  /// - appointment: Objeto [Appointment] con los datos de la cita
  ///   (el campo [idNoti] será sobrescrito por el servicio)
  ///
  /// Lanza:
  /// [Exception] si no hay usuario autenticado
  static Future<void> addAppointment(Appointment appointment) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    final newAppointment = appointment.copyWith(idNoti: _contNoti++);

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .add(newAppointment.toMap());

    //await Functions.programarNotificacionesDeCitas();
  }

  /// Elimina una cita existente.
  ///
  /// Parámetros:
  /// - idAppointment: ID del documento a eliminar
  ///
  /// Lanza:
  /// [Exception] si no hay usuario autenticado
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

  /// Actualiza los datos de una cita existente utilizando el modelo [Appointment].
  ///
  /// Parámetros:
  /// - appointment: Objeto [Appointment] completo con los datos actualizados
  ///   (debe incluir el ID del documento en Firestore)
  ///
  /// Lanza:
  /// [Exception] si:
  ///   - No hay usuario autenticado
  ///   - El objeto no tiene ID
  static Future<void> updateAppointment(Appointment appointment) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    if (appointment.id == null) {
      throw Exception('ID de cita no proporcionado');
    }

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('appointments')
        .doc(appointment.id)
        .update(appointment.toMap());
  }
}
