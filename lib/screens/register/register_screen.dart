import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:heraguard/widgets/form_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name':
                _nameController.text.trim(),
          });
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Error al crear la cuenta';
      if (error.code == 'weak-password') {
        errorMessage = 'La contraseña es demasiado débil';
      } else if (error.code == 'email-already-in-use') {
        errorMessage = 'Ya existe una cuenta con este correo';
      } else if (error.code == 'invalid-email') {
        errorMessage = 'Correo inválido';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear Cuenta',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  Icons.security,
                  size: 70,
                  color: Color.fromRGBO(35, 150, 230, 1),
                ),
                SizedBox(height: 10),
                Text(
                  "Únete a nosotros",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(35, 150, 230, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                FormRegister(
                  formKey: _formKey,
                  nameComtroller: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onSubmit: _register,
                  onLoginPressed: () => Navigator.pop(context),
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
