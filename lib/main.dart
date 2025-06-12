import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/firebase_options.dart';
import 'package:heraguard/routes/my_routes.dart';
import 'package:heraguard/screens/splash_screen.dart';
import 'package:heraguard/services/notification_service.dart';

/// Archivo principal de la aplicación.
/// Realiza las siguientes inicializaciones:
/// 1. Configuración de Flutter Engine [WidgetsFlutterBinding]
/// 2. Inicialización de Firebase con configuraciones específicas
/// 3. Configuración del servicio de notificaciones y solicitud de permisos
/// 4. Lanzamiento de la aplicación principal [MyApp]

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  runApp(const MyApp());
}

/// Widget raíz de la aplicación que configura el MaterialApp.
/// Características principales:
/// - Desactiva el banner de debug
/// - Define el título global de la aplicación
/// - Establece [SplashScreen] como pantalla inicial
/// - Configura las rutas disponibles mediante [MyRoutes]

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeraGuard',
      home: SplashScreen(),
      //initialRoute: MyRoutes.initialRoute,
      routes: MyRoutes.allRoutes(),
    );
  }
}
