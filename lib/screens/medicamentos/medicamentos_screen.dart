import 'package:flutter/material.dart';
import 'package:heraguard/controllers/medicine_controller.dart';
import 'package:heraguard/models/medicine_model.dart';
import 'package:heraguard/screens/medicamentos/actualizar_medicamento.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:provider/provider.dart';

/// Pantalla principal para la visualización y gestión de medicamentos registrados.
/// Muestra una lista interactiva de medicamentos con capacidad para agregar, editar y eliminar registros.
/// Se integra con el MedicineService para obtener datos y actualizar la interfaz de manera reactiva.
/// Características Principales
/// - Muestra lista completa de medicamentos registrados
/// - Permite agregar nuevos medicamentos
/// - Ofrece funcionalidad de edición y eliminación por cada ítem
/// - Actualización automática de la lista tras modificaciones
/// - Manejo de estados de carga y vacío
/// - Diseño con tarjetas informativas
///
/// Flujo:
/// 1. Al iniciar, carga los medicamentos mediante MedicineService
/// 2. Renderiza la lista usando FutureBuilder
/// 3. Actualiza la vista cuando:
///    - Se agrega un nuevo medicamento
///    - Se edita un medicamento existente
///    - Se elimina un registro
///
/// Dependencias
/// - medicine_service.dart: Servicio para obtener datos de medicamentos
/// - actualizar_medicamento.dart: Pantalla de edición
/// - agregar_medicamento.dart: Pantalla de creación de medicamento
/// - functions.dart: Archivo de funciones
/// - widgets/: Widgets a utilizar en la pantalla

class MedicamentosScreen extends StatefulWidget {
  const MedicamentosScreen({super.key});

  @override
  State<MedicamentosScreen> createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  late Future<List<Medicine>> _medicationsFuture;

  /// Carga/re-carga la lista de medicamentos desde el servicio
  Future<void> _loadMedications() async {
    setState(() {
      _medicationsFuture = MedicineService.getMedications();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMedications();
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
            Text(
              'Medicamentos',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Medicine>>(
                future: _medicationsFuture,
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
                      child: Text("No hay medicamentos registrados"),
                    );
                  }
                  final medications = snapshot.data!;
                  return ListView.builder(
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medicine = medications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        color: Color.fromRGBO(35, 150, 230, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nombre: ${medicine.name}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
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
                                                      (context) =>
                                                          ActualizarMedicamento(
                                                            idMedicine:
                                                                medicine.id!,
                                                          ),
                                                ),
                                              );

                                          if (actualizado == true) {
                                            _loadMedications();
                                          }
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.amber,
                                        iconSize: 35,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final controller =
                                              Provider.of<MedicineController>(
                                                context,
                                                listen: false,
                                              );
                                          await controller.deleteMedicine(
                                            context: context,
                                            idMedicine: medicine.id!,
                                            idNoti: medicine.idNotiM,
                                          );
                                          _loadMedications();
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
                                'Dosis: ${medicine.dose}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Duración: ${medicine.durationNumber} ${medicine.duration}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Frecuencia: ${medicine.frequency}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                MaterialPageRoute(builder: (context) => AgregarMedicamento()),
              );
              if (result == true) {
                _loadMedications();
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
