/// Modelo que representa un medicamento en el sistema de gestión médica.
/// Contiene información sobre medicamentos recetados, incluyendo dosis,
/// frecuencia y horarios, con soporte para notificaciones programadas.
class Medicine {
  final String? id;
  final int idNotiM;
  final String? route;
  final String name;
  final String dose;
  final String? frequency;
  final String? specificTime;
  final String? duration;
  final String durationNumber;
  final String startDate;

  Medicine({
    this.id,
    required this.idNotiM,
    this.route,
    required this.name,
    required this.dose,
    this.frequency,
    this.specificTime,
    this.duration,
    required this.durationNumber,
    required this.startDate,
  });

  /// Serializa el objeto a formato compatible con Firestore
  /// 
  /// Retorna:
  /// [Map<String, dynamic>] con la estructura adecuada para Firestore,
  /// excluyendo el campo [id] que es manejado separadamente.
  Map<String, dynamic> toMap() {
    return {
      'idNotiM': idNotiM,
      'route': route,
      'name': name,
      'dose': dose,
      'frequency': frequency,
      'specificTime': specificTime,
      'duration': duration,
      'durationNumber': durationNumber,
      'startDate': startDate,
    };
  }

  /// Constructor desde datos de Firestore
  /// Parámetros:
  /// - [map]: Datos del documento Firestore
  /// - [id]: ID del documento en Firestore
  /// 
  /// Retorna:
  /// Nueva instancia de [Medicine] con todos los campos mapeados,
  /// usando valores por defecto para campos requeridos si son null.
  factory Medicine.fromMap(Map<String, dynamic> map, String id) {
    return Medicine(
      id: id,
      idNotiM: map['idNotiM'] ?? 0,
      route: map['route'],
      name: map['name'] ?? '',
      dose: map['dose'] ?? '',
      frequency: map['frequency'],
      specificTime: map['specificTime'],
      duration: map['duration'],
      durationNumber: map['durationNumber'] ?? '',
      startDate: map['startDate'] ?? '',
    );
  }

  /// Crea una copia modificada de este medicamento
  /// Parámetros:
  /// Campos opcionales a modificar. Los no especificados mantienen su valor.
  /// 
  /// Retorna:
  /// Nueva instancia de [Medicine] con los cambios aplicados.
  Medicine copyWith({
    String? id,
    int? idNotiM,
    String? route,
    String? name,
    String? dose,
    String? frequency,
    String? specificTime,
    String? duration,
    String? durationNumber,
    String? startDate,
  }) {
    return Medicine(
      id: id ?? this.id,
      idNotiM: idNotiM ?? this.idNotiM,
      route: route ?? this.route,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      specificTime: specificTime ?? this.specificTime,
      duration: duration ?? this.duration,
      durationNumber: durationNumber ?? this.durationNumber,
      startDate: startDate ?? this.startDate,
    );
  }

  /// Descripción completa del medicamento
  /// 
  /// Retorna:
  /// [String] en formato "Nombre Dosis Frecuencia" (ej: "Paracetamol 500mg Cada 8 horas")
  String get descripcionCompleta {
    return '$name $dose ${frequency ?? ''}'.trim();
  }

  /// Verifica si el medicamento tiene hora específica de administración
  /// 
  /// Retorna:
  /// [true] si tiene hora específica definida, [false] en caso contrario
  bool get tieneHoraEspecifica {
    return specificTime != null && specificTime!.isNotEmpty;
  }
}