import 'package:flutter/material.dart';
import 'package:heraguard/functions/functions.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';

class AgregarMedicamento extends StatefulWidget {
  const AgregarMedicamento({super.key});

  @override
  State<AgregarMedicamento> createState() => _AgregarMedicamentoState();
}

class _AgregarMedicamentoState extends State<AgregarMedicamento> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _specificTimeController = TextEditingController();
  final _durationController = TextEditingController();
  final _routeOfAdminController = TextEditingController();
  final onTapFunction = Function;

  final _formKey = GlobalKey<FormState>();

  String? dropDownValue;

  void funDrop(String? value) {
    setState(() {
      dropDownValue = value;
    });
  }

  final List<String> _tiposTratamiento = [
    'Tomado (Oral)',
    'Inyectado',
    'Tópico',
  ];

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
                    'Agregar Tratamiento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width * 0.92,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      iconSize: 30,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      hint: Text(
                        'Seleccione el tipo de tratamiento',
                        style: TextStyle(color: Colors.white),
                      ),
                      items:
                          _tiposTratamiento.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                      value: dropDownValue,
                      onChanged: funDrop,
                      underline: Container(),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nombre',
                    icon: Icons.medication,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _doseController,
                    label: 'Dosis',
                    icon: Icons.exposure,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _frequencyController,
                    label: 'Frecuencia',
                    icon: Icons.repeat,
                    onTap:
                        () => Functions.showTime(
                          context: context,
                          controller: _frequencyController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _specificTimeController,
                    label: 'Hora Especifica (Opcional)',
                    icon: Icons.access_time,
                    onTap:
                        () => Functions.showTime(
                          context: context,
                          controller: _specificTimeController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _durationController,
                    label: 'Duracion',
                    icon: Icons.calendar_today,
                    onTap:
                        () => Functions.showCalendar(
                          context: context,
                          controller: _durationController,
                        ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _routeOfAdminController,
                    label: 'Via de Administracion',
                    icon: Icons.alt_route,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          () => Functions.guardarTratamiento(
                            context: context,
                            dropOption: dropDownValue,
                            nameController: _nameController,
                            doseController: _doseController,
                            frequencyController: _frequencyController,
                            specificTimeController: _specificTimeController,
                            durationController: _durationController,
                            routeController: _routeOfAdminController,
                          ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                      ),
                      child: Text(
                        'Guardar Tratamiento',
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
