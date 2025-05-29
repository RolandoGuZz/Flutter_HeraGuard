import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heraguard/firebase_options.dart';
import 'package:heraguard/routes/my_routes.dart';
import 'package:heraguard/screens/splash_screen.dart';
import 'package:heraguard/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  //await Functions.programarNotificacionesDeCitas();

  runApp(const MyApp());
}

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
