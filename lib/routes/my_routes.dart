import 'package:flutter/material.dart';
import 'package:heraguard/models/menu_model.dart';
import 'package:heraguard/screens/login_screen.dart';
import 'package:heraguard/screens/screens.dart';

class MyRoutes {
  static final initialRoute = 'login';

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
    MenuOptions(
      icon: Icons.notifications,
      option: 'Notificaciones',
      ruta: 'notificaciones',
      screen: NotificacionesScreen(),
    ),
  ];

  static Map<String, Widget Function(BuildContext)> allRoutes() {
    Map<String, Widget Function(BuildContext)> t = {};
    final routes = [...publicRoutes, ...privateRoutes];
    for (var option in routes) {
      t.addAll({option.ruta: (BuildContext c) => option.screen});
    }
    return t;
  }

  static Map<String, Widget Function(BuildContext)> menuRoutes() {
    Map<String, Widget Function(BuildContext)> t = {};
    for (var option in privateRoutes) {
      t.addAll({option.ruta: (BuildContext c) => option.screen});
    }
    return t;
  }
}
