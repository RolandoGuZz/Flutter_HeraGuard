import 'package:flutter/material.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/models/appointment_model.dart';
import 'package:heraguard/screens/citas_medicas/actualizar_cita.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/widgets/sidebar.dart';
import 'package:heraguard/widgets/appbar_widget.dart';

/// Pantalla principal para visualizar y administrar las citas médicas registradas.
/// Muestra una lista interactiva de citas con capacidad para agregar, editar y eliminar registros.
/// Se integra con el AppointmentService para obtener datos y actualizar la interfaz de manera reactiva.
/// Características Principales
/// - Muestra lista completa de citas médicas registradas
/// - Permite agregar nuevas citas
/// - Ofrece funcionalidad de edición y eliminación por cada ítem
/// - Actualización automática de la lista tras modificaciones
/// - Manejo de estados de carga y vacío
/// - Diseño con tarjetas informativas
///
/// Flujo:
/// 1. Al iniciar, carga las citas mediante AppointmentService
/// 2. Renderiza la lista usando FutureBuilder
/// 3. Actualiza la vista cuando:
///    - Se agrega una nueva cita
///    - Se edita una cita existente
///    - Se elimina un registro
///
/// Dependencias
/// - appointment_service.dart: Servicio para obtener datos de citas
/// - actualizar_cita.dart: Pantalla de edición
/// - agregar_cita.dart: Pantalla de creación de cita
/// - functions.dart: Archivo de funciones
/// - widgets/: Widgets a utilizar en la pantalla

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  late Future<List<Appointment>> _appointmentsFuture;

  /// Carga/re-carga la lista de citas desde el servicio
  Future<void> _loadAppointments() async {
    setState(() {
      _appointmentsFuture = AppointmentService.getAppointments();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppbarWidget(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Citas Médicas',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Appointment>>(
                future: _appointmentsFuture,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(35, 150, 230, 1),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No hay citas registradas"),
                    );
                  }
                  final appointments = snapshot.data!;
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        color: Color.fromRGBO(35, 150, 230, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Fecha: ${appointment.date}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final actualizado =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => ActualizarCita(
                                                        idAppointment:
                                                            appointment.id!,
                                                      ),
                                                ),
                                              );

                                          if (actualizado == true) {
                                            _loadAppointments();
                                          }
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: Colors.amber,
                                        iconSize: 35,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await Functions.eliminarCita(
                                            context: context,
                                            idAppointment: appointment.id!,
                                          );
                                          _loadAppointments();
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        iconSize: 35,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                'Hora: ${appointment.time}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dirección: ${appointment.address}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarCita()),
              );
              if (result == true) {
                _loadAppointments();
              }
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.plus_one, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
