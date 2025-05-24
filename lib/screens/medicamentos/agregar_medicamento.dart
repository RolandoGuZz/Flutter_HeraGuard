import 'package:flutter/material.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:heraguard/widgets/drop_down_button_widget.dart';

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
                              ? () => Functions.guardarMedicamento(
                                context: context,
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
                        backgroundColor:
                            _formValid()
                                ? Color.fromRGBO(35, 150, 230, 1)
                                : Colors.grey,
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
