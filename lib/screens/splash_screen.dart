import 'package:flutter/material.dart';
import 'package:heraguard/routes/my_routes.dart';

/// Pantalla de presentación inicial que se muestra al abrir la aplicación.
/// Realiza las siguientes funciones:
/// - Muestra el logo y nombre de la aplicación "HeraGuard"
/// - Mantiene una animación de carga durante 2 segundos
/// - Navega automáticamente a la ruta inicial definida en [MyRoutes.initialRoute] que es el login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, MyRoutes.initialRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: Colors.white, size: 60),
            SizedBox(height: 15),
            Text(
              'HeraGuard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
