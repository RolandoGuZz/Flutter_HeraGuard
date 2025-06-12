import 'package:flutter/material.dart';
import 'package:heraguard/routes/my_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Barra lateral de navegación principal con:
/// - Encabezado
/// - Lista dinámica de rutas privadas
/// - Opción de cierre de sesión
///
/// Estructura
/// 1. Encabezado superior:
///    - Color azul corporativo
///    - Texto "Menu" en blanco
/// 2. Lista de rutas:
///    - Generada dinámicamente desde [MyRoutes.privateRoutes]
///    - Iconos azules con texto negro
///    - Navegación mediante [Navigator.pushNamed]
/// 3. Cierre de sesión:
///    - Botón rojo prominente
///    - Desautentica con [FirebaseAuth]
///    - Redirige a pantalla de login (eliminando historial)
///
/// Consideraciones de seguridad
/// - Solo muestra rutas marcadas como privadas
/// - Al cerrar sesión:
///   - Elimina credenciales con [FirebaseAuth.signOut]
///   - Limpia el stack de navegación lo cual evita el retroceso
///   - Redirige a la ruta pública 'login'

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(color: Color.fromRGBO(35, 150, 230, 1)),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...MyRoutes.privateRoutes.map(
                  (menuItem) => ListTile(
                    leading: Icon(menuItem.icon, color: Colors.blue),
                    title: Text(
                      menuItem.option,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, menuItem.ruta);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  'login',
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
