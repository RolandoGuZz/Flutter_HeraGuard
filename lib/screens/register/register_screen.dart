// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/screens/login/login_screen.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:heraguard/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  //final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    //if (!_formKey.currentState!.validate()) return;
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
          .set({'name': _nameController.text.trim()});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenido ${userCredential.user!.email}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Color.fromRGBO(35, 150, 230, 1),
        ),
      );
      Navigator.pushReplacement(
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

  void _navigateToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  bool _formRegisterValido() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

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
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre',
                  icon: Icons.person,
                  textCap: TextCapitalization.words,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _formRegisterValido()
                            ? _register
                            : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 0),
                      backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Crear Cuenta',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    '¿Ya tienes cuenta? Inicia Sesión',
                    style: TextStyle(
                      color: Color.fromRGBO(35, 150, 230, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
