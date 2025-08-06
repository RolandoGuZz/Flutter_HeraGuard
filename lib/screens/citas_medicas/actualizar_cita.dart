import 'package:flutter/material.dart';
import 'package:heraguard/controllers/appointment_controller.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

/// Pantalla para modificar los datos de una cita existente.
/// Precarga la información actual de la cita y permite su actualización mediante un formulario validado.
/// Características Principales
/// - Precarga datos existentes de la cita seleccionada
/// - Formulario con validación de campos obligatorios
/// - Selectores de fecha/hora integrados
/// - Integración con servicio de actualización
/// - Actualización reactiva de la interfaz
///
/// Parámetros Requeridos
/// - [idAppointment]: ID de la cita a editar
///
/// Flujo:
/// 1. Carga inicial de datos de la cita (initState)
/// 2. Validación en tiempo real de campos
/// 3. Envío de datos actualizados al servicio
///
/// Validaciones
/// - Fecha, hora y dirección son campos obligatorios
/// - Nombre del doctor es opcional
/// - Botón deshabilitado hasta validación completa
///
/// Dependencias
/// - appointment_service.dart: Servicio para obtener/actualizar datos de citas
/// - functions.dart: Funciones para selectores y actualización
/// - widgets/: Widgets a utilizar en la pantalla

class ActualizarCita extends StatefulWidget {
  final String idAppointment;
  const ActualizarCita({super.key, required this.idAppointment});

  @override
  State<ActualizarCita> createState() => _ActualizarCitaState();
}

class _ActualizarCitaState extends State<ActualizarCita> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _doctorController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Valida si los campos obligatorios contienen datos
  bool _formCitaValido() {
    return _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;
  }

  /// Configura listeners para actualización reactiva
  @override
  void initState() {
    super.initState();
    _dateController.addListener(_updateState);
    _timeController.addListener(_updateState);
    _addressController.addListener(_updateState);

    /// Carga los datos actuales de la cita
    AppointmentService.getAppointment(idAppointment: widget.idAppointment).then(
      (appointment) {
        if (mounted) {
          setState(() {
            _dateController.text = appointment.date;
            _timeController.text = appointment.time;
            _addressController.text = appointment.address;
            _doctorController.text = appointment.doctor ?? '';
          });
        }
      },
    );
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Agregar Cita',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _dateController,
                    label: 'Fecha',
                    icon: Icons.calendar_today,
                    onTap:
                        () => Functions.showCalendar(
                          context: context,
                          controller: _dateController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _timeController,
                    label: 'Hora',
                    icon: Icons.access_time,
                    onTap:
                        () => Functions.showTime(
                          context: context,
                          controller: _timeController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _doctorController,
                    label: 'Nombre Doctor (Opcional)',
                    icon: Icons.person,
                    textCap: TextCapitalization.words,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _addressController,
                    label: 'Dirección',
                    icon: Icons.place,
                    textCap: TextCapitalization.words,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _formCitaValido()
                              ? () async {
                                final controller =
                                    Provider.of<AppointmentController>(
                                      context,
                                      listen: false,
                                    );
                                await controller.updateAppointment(
                                  context: context,
                                  idAppointment: widget.idAppointment,
                                  dateController: _dateController,
                                  timeController: _timeController,
                                  doctorController: _doctorController,
                                  addressController: _addressController,
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                      ),
                      child: Text(
                        'Actualizar Cita',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
