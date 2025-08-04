import 'package:flutter/material.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:heraguard/widgets/drop_down_button_widget.dart';

/// Pantalla para modificar los datos de un medicamento existente.
/// Precarga la información actual del medicamento y permite su actualización mediante un formulario validado.
/// Características Principales
/// - Precarga datos existentes del medicamento seleccionado
/// - Formulario con validación de campos obligatorios
/// - Selectores desplegables para opciones predefinidas
/// - Integración con servicio de actualización
/// - Actualización reactiva de la interfaz
///
/// Parámetros Requeridos
/// - [idMedicine]: ID del medicamento a editar
///
/// Flujo:
/// 1. Carga inicial de datos del medicamento (initState)
/// 3. Validación en tiempo real de campos
/// 4. Envío de datos actualizados al servicio
///
/// Validaciones
/// - Todos los campos principales son obligatorios
/// - Los dropdowns deben mantener selección válida
/// - Botón deshabilitado hasta validación completa
///
/// Dependencias
/// - medicine_service.dart: Servicio para obtener/actualizar datos
/// - functions.dart: Funciones para selectores y actualización
/// - widgets/: Widgets a utilizar en la pantalla

class ActualizarMedicamento extends StatefulWidget {
  final String idMedicine;
  const ActualizarMedicamento({super.key, required this.idMedicine});

  @override
  State<ActualizarMedicamento> createState() => _ActualizarMedicamentoState();
}

class _ActualizarMedicamentoState extends State<ActualizarMedicamento> {
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

  /// Valida si el formulario está completo
  bool _formValid() {
    return _nameController.text.isNotEmpty &&
        _doseController.text.isNotEmpty &&
        _durationNumberController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _routeInitial != null &&
        _frequencyInitial != null &&
        _durationInitial != null;
  }

  /// Configura listeners para actualización reactiva
  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _doseController.addListener(_updateState);
    _durationNumberController.addListener(_updateState);
    _startDateController.addListener(_updateState);

    /// Carga los datos actuales del medicamento
    MedicineService.getMedicine(idMedicine: widget.idMedicine).then((medicine) {
      if (mounted) {
        setState(() {
          _nameController.text = medicine.name;
          _doseController.text = medicine.dose;
          _durationNumberController.text = medicine.durationNumber;
          _startDateController.text = medicine.startDate;
          _specificTimeController.text = medicine.specificTime ?? '';
          _routeInitial = medicine.route;
          _frequencyInitial = medicine.frequency;
          _durationInitial = medicine.duration;
        });
      }
    });
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
                    label: 'Hora Específica (Opcional)',
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
                              ? () => Functions.actualizarMedicamento(
                                context: context,
                                idMedicine: widget.idMedicine,
                                routeValue: _routeInitial,
                                nameController: _nameController,
                                doseController: _doseController,
                                frequencyValue: _frequencyInitial,
                                specificTimeController: _specificTimeController,
                                durationValue: _durationInitial,
                                durationController: _durationNumberController,
                                startDateController: _startDateController,
                              )
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                      ),
                      child: Text(
                        'Actualizar Medicamento',
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
