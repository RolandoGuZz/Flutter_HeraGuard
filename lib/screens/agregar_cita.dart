import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heraguard/widgets/appbar_widget.dart';

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

  Future<void> _guardarCita() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Agregar Cita',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _buildTextField(_dateController, 'Fecha', Icons.date_range),
                const SizedBox(height: 20),

                _buildTextField(_timeController, 'Hora', Icons.lock_clock),
                const SizedBox(height: 20),

                _buildTextField(
                  _doctorController,
                  'Doctor',
                  Icons.supervised_user_circle,
                ),
                const SizedBox(height: 20),

                _buildTextField(_addressController, 'Dirección', Icons.place),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _guardarCita,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(35, 150, 230, 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Guardar Cita',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
