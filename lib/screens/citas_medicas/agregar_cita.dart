import 'package:flutter/material.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/controllers/appointment_controller.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

/// Pantalla de formulario para el registro de nuevas citas médicas en el sistema.
/// Captura información esencial como fecha, hora, doctor (opcional) y dirección.
/// Características Principales
/// - Formulario validado con campos obligatorios
/// - Selectores de fecha y hora integrados
/// - Validación en tiempo real del formulario
/// - Campo opcional para nombre del doctor
///
/// Flujo:
/// 1. Selección de fecha y hora mediante pickers
/// 2. Captura de datos de la cita
/// 3. Validación automática del formulario
/// 4. Confirmación mediante botón de guardado
/// 5. Envío de datos a través de función especializada
///
/// Validaciones
/// - Fecha, hora y dirección son campos obligatorios
/// - Nombre del doctor es opcional
/// - Habilitación condicional del botón de guardado
///
/// Dependencias
/// - functions.dart: Contiene lógica para mostrar selectores y guardar datos
/// - widgets/: Widgets a utilizar en la pantalla

class AgregarCita extends StatefulWidget {
  const AgregarCita({super.key});

  @override
  State<AgregarCita> createState() => _AgregarCitaState();
}

class _AgregarCitaState extends State<AgregarCita> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _doctorController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Valida si todos los campos requeridos están completos
  bool _formCitaValido() {
    return _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_updateState);
    _timeController.addListener(_updateState);
    _addressController.addListener(_updateState);
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
                                await controller.saveAppointment(
                                  context: context,
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
                        'Guardar Cita',
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
