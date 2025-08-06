import 'package:flutter/material.dart';
import 'package:heraguard/controllers/medicine_controller.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:heraguard/widgets/drop_down_button_widget.dart';
import 'package:provider/provider.dart';

/// Pantalla de formulario para el registro de nuevos medicamentos en el sistema.
/// Captura toda la información necesaria incluyendo nombre, dosis, frecuencia, vía de administración y duración del tratamiento.
/// Características Principales
/// - Formulario validado con campos obligatorios
/// - Selectores desplegables para opciones predefinidas
/// - Selectores de fecha y hora integrados
/// - Validación en tiempo real del formulario
///
/// Flujo:
/// 1. Captura y validación de datos en el formulario
/// 2. Selección de opciones mediante dropdowns
/// 3. Confirmación mediante botón de guardado
/// 4. Envío de datos a través de función especializada
///
/// Validaciones
/// - Todos los campos principales son obligatorios
/// - Los dropdowns deben tener selección válida
/// - Habilitación condicional del botón de guardado
///
/// Dependencias
/// - functions.dart: Contiene lógica para mostrar selectores y guardar datos
/// - widgets/: Widgets a utilizar en la pantalla

class AgregarMedicamento extends StatefulWidget {
  const AgregarMedicamento({super.key});

  @override
  State<AgregarMedicamento> createState() => _AgregarMedicamentoState();
}

class _AgregarMedicamentoState extends State<AgregarMedicamento> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _specificTimeController = TextEditingController();
  final _durationNumberController = TextEditingController();
  final _startDateController = TextEditingController();
  final onTapFunction = Function;

  final _formKey = GlobalKey<FormState>();

  String? _routeInitial;
  String? _frequencyInitial;
  String? _durationInitial;

  /// Maneja la selección de los dropdowns
  void selectRoute(String? value) {
    setState(() {
      _routeInitial = value;
    });
  }

  void selectFrequency(String? value) {
    setState(() {
      _frequencyInitial = value;
    });
  }

  void selectDuration(String? value) {
    setState(() {
      _durationInitial = value;
    });
  }

  /// Opciones para los dropdowns
  final List<String> _routesOfAdmin = [
    'Tomado (Oral)',
    'Inyectado',
    'Tópico',
    'Inhalado',
    'Sublingual',
  ];

  final List<String> _frequencyHours = [
    'Cada 4 horas',
    'Cada 6 horas',
    'Cada 8 horas',
    'Cada 12 horas',
    'Cada 24 horas ',
  ];

  final List<String> __durationsOptions = [
    'Dias',
    'Semanas',
    'Meses',
    'Permanente',
  ];

  /// Valida si todos los campos requeridos están completos
  bool _formValid() {
    return _nameController.text.isNotEmpty &&
        _doseController.text.isNotEmpty &&
        _durationNumberController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _routeInitial != null &&
        _frequencyInitial != null &&
        _durationInitial != null;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _doseController.addListener(_updateState);
    _durationNumberController.addListener(_updateState);
    _startDateController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    'Agregar Medicamento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nombre',
                    icon: Icons.medication,
                    textCap: TextCapitalization.words,
                  ),
                  SizedBox(height: 20),
                  DropDownButtonWidget(
                    size: size,
                    listOfOptions: _routesOfAdmin,
                    valueInitial: _routeInitial,
                    funSelectOption: selectRoute,
                    hintText: Text(
                      'Seleccione la via de administración',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _doseController,
                    label: 'Dosis',
                    icon: Icons.exposure,
                  ),
                  SizedBox(height: 20),
                  DropDownButtonWidget(
                    size: size,
                    listOfOptions: _frequencyHours,
                    valueInitial: _frequencyInitial,
                    funSelectOption: selectFrequency,
                    hintText: Text(
                      'Seleccione la frecuencia',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _specificTimeController,
                    label: 'Hora Específica',
                    icon: Icons.access_time,
                    onTap:
                        () => Functions.showTime(
                          context: context,
                          controller: _specificTimeController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  DropDownButtonWidget(
                    size: size,
                    listOfOptions: __durationsOptions,
                    valueInitial: _durationInitial,
                    funSelectOption: selectDuration,
                    hintText: Text(
                      'Seleccione la duración',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _durationNumberController,
                    keyboardType: TextInputType.number,
                    label: 'Duracion',
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _startDateController,
                    label: 'Fecha de Inicio',
                    icon: Icons.calendar_today,
                    onTap:
                        () => Functions.showCalendar(
                          context: context,
                          controller: _startDateController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _formValid()
                              ? () async {
                                final controller =
                                    Provider.of<MedicineController>(
                                      context,
                                      listen: false,
                                    );
                                await controller.saveMedicine(
                                  context: context,
                                  routeValue: _routeInitial,
                                  nameController: _nameController,
                                  doseController: _doseController,
                                  frequencyValue: _frequencyInitial,
                                  specificTimeController:
                                      _specificTimeController,
                                  durationValue: _durationInitial,
                                  durationController: _durationNumberController,
                                  startDateController: _startDateController,
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                      ),
                      child: Text(
                        'Guardar Medicamento',
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
