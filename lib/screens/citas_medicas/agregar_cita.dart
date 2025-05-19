import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

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
  final onTapFunction = Function;

  final _formKey = GlobalKey<FormState>();

  Future<void> _guardarCita() async {
    final user = FirebaseAuth.instance.currentUser;
    // if (user == null) return;
    final uid = user!.uid;
    final citaData = {
      'date': _dateController.text,
      'time': _timeController.text,
      'doctor': _doctorController.text,
      'address': _addressController.text,
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('appointments')
        .add(citaData);
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          'Cita guardada con éxito',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      ),
    );
    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(35, 150, 230, 1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

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
                  _buildTextField(_dateController, 'Fecha', Icons.date_range, _selectDate, true),
                  SizedBox(height: 20),
                  _buildTextField(
                    _timeController,
                    'Hora',
                    Icons.lock_clock,
                    () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        // ignore: use_build_context_synchronously
                        _timeController.text = time.format(context);
                      }
                    },
                    true,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_doctorController, 'Doctor', Icons.person),
                  SizedBox(height: 20),
                  _buildTextField(_addressController, 'Dirección', Icons.place),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guardarCita,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    VoidCallback? onTap,
    bool readOnly = false,
  ]) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onTap: onTap,
    );
  }
}
