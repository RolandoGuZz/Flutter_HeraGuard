import 'package:flutter/material.dart';

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