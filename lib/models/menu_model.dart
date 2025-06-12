import 'package:flutter/material.dart';

/// Modelo que representa una opción del menú.
/// Se encarga de:
/// - Almacenar la estructura de datos para opciones de navegación.
/// - Centralizar la configuración de rutas y pantallas asociadas.
/// - Facilitar la consistencia en menús y sistemas de navegación.
/// 
/// ## Atributos:
/// - [icon]: Icono visual para la opción.
/// - [option]: Nombre descriptivo de la opción.
/// - [ruta]: Identificador único para navegación.
/// - [screen]: Pantalla destino al seleccionar la opción.

class MenuOptions {
  final IconData icon;
  final String option;
  final String ruta;
  final Widget screen;

  MenuOptions({
    required this.icon,
    required this.option,
    required this.ruta,
    required this.screen,
  });
}