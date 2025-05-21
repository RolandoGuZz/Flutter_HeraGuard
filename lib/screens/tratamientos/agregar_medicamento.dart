import 'package:flutter/material.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/custom_text_field.dart';

class AgregarMedicamento extends StatefulWidget {
  const AgregarMedicamento({super.key});

  @override
  State<AgregarMedicamento> createState() => _AgregarMedicamentoState();
}

class _AgregarMedicamentoState extends State<AgregarMedicamento> {
  final _typeController = TextEditingController();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _specificTimeController = TextEditingController();
  final _durationController = TextEditingController();
  final _routeOfAdminController = TextEditingController();
  final onTapFunction = Function;

  final _formKey = GlobalKey<FormState>();

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
                    'Agregar Tratamiento',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _typeController,
                    label: 'Tipo',
                    icon: Icons.category,
                    onTap: () {},
                    readOnly: true,
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
                    onTap: () {},
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _specificTimeController,
                    label: 'Hora Especifica (Opcional)',
                    icon: Icons.access_time,
                    onTap: () {},
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _durationController,
                    label: 'Duracion',
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: _routeOfAdminController,
                    label: 'Via de Administracion',
                    icon: Icons.alt_route,
                    onTap: () {},
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
