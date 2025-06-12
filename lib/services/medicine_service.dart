import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/functions/functions.dart';

/// Servicio para gestionar medicamentos en Firestore.
/// Proporciona operaciones CRUD para los medicamentos del usuario autenticado,
/// almacenados en la subcolección 'medications' del documento del usuario.

class MedicineService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static int _contNoti = 0;

  /// Obtiene todos los medicamentos del usuario actual.
  /// Características:
  /// - Retorna lista vacía si no hay usuario autenticado
  /// - Cada medicamento incluye sus datos + ID del documento
  ///
  /// Retorna:
  /// [List<Map<String, dynamic>>] donde cada mapa contiene:
  ///   - Campos del medicamento (name, dose, frequency, etc.)
  ///   - id: ID del documento en Firestore
  ///   - idNotiM: ID de notificación asociada
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

  /// Obtiene un medicamento específico por su ID.
  /// Parámetros:
  /// - idMedicine: ID del documento del medicamento
  ///
  /// Lanza:
  /// Exception si:
  ///   - No hay usuario autenticado
  ///   - El medicamento no existe
  ///
  /// Retorna:
  /// - [Map<String, dynamic>] con los datos del medicamento + ID del documento
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

  /// Agrega un nuevo medicamento.
  /// Comportamiento:
  /// 1. Valida usuario autenticado
  /// 2. Genera ID de notificación único
  /// 3. Guarda en Firestore
  /// 4. Programa notificación local
  ///
  /// Parámetros:
  /// - route: Vía de administración (opcional)
  /// - name: Nombre del medicamento
  /// - dose: Dosis del medicamento
  /// - frequency: Frecuencia (opcional)
  /// - specificTime: Hora específica (opcional)
  /// - duration: Duración del tratamiento (opcional)
  /// - durationNumber: Número de días del tratamiento
  /// - startDate: Fecha de inicio
  ///
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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
    int idNotiM = _contNoti++;
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('medications')
        .add({
          'idNotiM': idNotiM,
          'route': route,
          'name': name,
          'dose': dose,
          'frequency': frequency,
          'specificTime': specificTime,
          'duration': duration,
          'durationNumber': durationNumber,
          'startDate': startDate,
        });

    await Functions.programarNotificacionesDeMedicamentos();
  }

  /// Elimina un medicamento existente.
  /// Parámetros:
  /// - idMedicine: ID del documento a eliminar
  ///
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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

  /// Actualiza los datos de un medicamento existente.
  ///
  /// Parámetros:
  /// - idMedicine: ID del documento a actualizar
  /// - data: Mapa con campos a modificar
  ///
  /// Lanza:
  /// - Exception si no hay usuario autenticado
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
