import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/widgets/custom_text_field.dart';
import 'package:heraguard/screens/screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  //final _formKeyLogin = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    //if (!_formKeyLogin.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (!mounted) return;
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
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Error al iniciar sesión';
      if (error.code == 'invalid-email') {
        errorMessage = 'Correo inválido';
      } else if (error.code == 'invalid-credential') {
        errorMessage = 'Correo o contraseña incorrectas';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterScreen()),
    );
  }

  bool _formLoginValido() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(35, 150, 230, 1),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Bienvenido a Heraguard",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromRGBO(35, 150, 230, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "El asistente para adultos mayores",
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(35, 150, 230, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _formLoginValido() ? _submitForm : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 0),
                      backgroundColor: Color.fromRGBO(35, 150, 230, 1),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Iniciar Sesión',
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
                  onPressed: _navigateToRegister,
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
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
