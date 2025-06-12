import 'package:flutter/material.dart';

/// Barra de aplicación personalizada que implementa [PreferredSizeWidget].
/// Características:
/// - Título centrado con el nombre de la aplicación "HeraGuard"
/// - Diseño color azul
/// - Iconos y texto en blanco para máximo contraste
/// - Altura estándar de la barra de herramientas de Flutter

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'HeraGuard',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(35, 150, 230, 1),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  /// Define la altura de la barra de aplicación.
  /// Utiliza la constante [kToolbarHeight] de Flutter para mantener
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
