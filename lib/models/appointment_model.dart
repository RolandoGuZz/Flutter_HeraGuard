/// Modelo que representa una cita médica en el sistema.
/// Encapsula todos los datos relacionados con una cita y proporciona métodos
/// para la conversión desde/hacia Firestore y actualizaciones seguras.
class Appointment {
  final String? id;
  final int idNoti;
  final String date;
  final String time;
  final String? doctor;
  final String address;

  Appointment({
    this.id,
    required this.idNoti,
    required this.date,
    required this.time,
    this.doctor,
    required this.address,
  });

  /// Convierte el objeto [Appointment] a un Map para almacenar en Firestore.
  /// 
  /// Retorna:
  /// [Map<String, dynamic>] con la estructura adecuada para Firestore.
  /// No incluye el campo [id] porque Firestore lo maneja automáticamente.
  Map<String, dynamic> toMap() {
    return {
      'idNoti': idNoti,
      'date': date,
      'time': time,
      'doctor': doctor,
      'address': address,
    };
  }

  /// Crea una instancia de [Appointment] a partir de datos de Firestore.
  /// 
  /// Parámetros:
  /// - [map]: Datos del documento de Firestore
  /// - [id]: ID del documento en Firestore
  /// 
  /// Retorna:
  /// Nueva instancia de [Appointment] con todos los campos mapeados.
  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      idNoti: map['idNoti'] ?? 0,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      doctor: map['doctor'],
      address: map['address'] ?? '',
    );
  }

  /// Crea una copia de esta cita con los campos especificados actualizados.
  /// Útil para actualizaciones parciales sin modificar el objeto original.
  /// 
  /// Parámetros:
  /// Campos opcionales que se desean modificar. Los no especificados
  /// mantendrán su valor original.
  /// 
  /// Retorna:
  /// Nueva instancia de [Appointment] con los cambios aplicados.
  Appointment copyWith({
    String? id,
    int? idNoti,
    String? date,
    String? time,
    String? doctor,
    String? address,
  }) {
    return Appointment(
      id: id ?? this.id,
      idNoti: idNoti ?? this.idNoti,
      date: date ?? this.date,
      time: time ?? this.time,
      doctor: doctor ?? this.doctor,
      address: address ?? this.address,
    );
  }

  /// Combina [date] y [time] en un solo String.
  /// Formato resultante: 'YYYY-MM-DD HH:MM'
  String get fullDateTime => '$date $time';

  /// Indica si la cita tiene un médico asignado.
  /// Retorna: [true] si [doctor] no es null ni vacío, [false] en caso contrario.
  bool get hasDoctor => doctor != null && doctor!.isNotEmpty;
}
