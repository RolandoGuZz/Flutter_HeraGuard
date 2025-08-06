import 'package:flutter/material.dart';
import 'package:heraguard/models/menu_model.dart';
import 'package:heraguard/screens/login/login_screen.dart';
import 'package:heraguard/screens/screens.dart';

/// Clase para la gestión de rutas y navegación en la aplicación.
/// Contiene:
/// - Rutas públicas (acceso sin autenticación)
/// - Rutas privadas (requieren autenticación)
/// - Métodos para generar mapas de rutas

class MyRoutes {
  /// Ruta inical de la aplicación.
  static final initialRoute = 'login';

  /// Lista de rutas accesibles sin autenticación.
  static final List<MenuOptions> publicRoutes = [
    MenuOptions(
      icon: Icons.login,
      option: 'Login',
      ruta: 'login',
      screen: LoginScreen(),
    ),
    MenuOptions(
      icon: Icons.app_registration,
      option: 'Register',
      ruta: 'register',
      screen: RegisterScreen(),
    ),
  ];

  /// Lista de rutas protegidas que requieren autenticación.
  static final List<MenuOptions> privateRoutes = [
    MenuOptions(
      icon: Icons.home,
      option: 'Home',
      ruta: 'home',
      screen: HomeScreen(),
    ),
    MenuOptions(
      icon: Icons.date_range_rounded,
      option: 'Citas Médicas',
      ruta: 'citas',
      screen: CitasScreen(),
    ),
    MenuOptions(
      icon: Icons.medication_liquid_rounded,
      option: 'Medicamentos',
      ruta: 'medicamentos',
      screen: MedicamentosScreen(),
    ),
    // MenuOptions(
    //   icon: Icons.notifications,
    //   option: 'Notificaciones',
    //   ruta: 'notificaciones',
    //   screen: NotificacionesScreen(),
    // ),
  ];

  /// Genera un mapa completo de rutas.
  /// Combina:
  /// - [publicRoutes]
  /// - [privateRoutes]
  /// Retorna:
  /// Un [Map<String, Widget Function(BuildContext)>] el cual escompatible con el sistema de rutas de Flutter.
  static Map<String, Widget Function(BuildContext)> allRoutes() {
    Map<String, Widget Function(BuildContext)> t = {};
    final routes = [...publicRoutes, ...privateRoutes];
    for (var option in routes) {
      t.addAll({option.ruta: (BuildContext c) => option.screen});
    }
    return t;
  }

  /// Genera un mapa solo con rutas del menú principal [privateRoutes].
  static Map<String, Widget Function(BuildContext)> menuRoutes() {
    Map<String, Widget Function(BuildContext)> t = {};
    for (var option in privateRoutes) {
      t.addAll({option.ruta: (BuildContext c) => option.screen});
    }
    return t;
  }
}
