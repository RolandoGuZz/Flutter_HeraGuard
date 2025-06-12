import 'package:flutter/material.dart';

/// Clase para crear un campo de texto personalizado.
/// Características:
/// - Estilo consistente con bordes negros y azul al enfocar
/// - Cuenta con icono personalizado
/// - Múltiples opciones de teclado (email, número, etc.)
/// - Configuración de capitalización de texto
/// - Modo de solo lectura
/// - Texto oculto (para contraseñas)

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final TextCapitalization textCap;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.label,
    required this.icon,
    this.onTap,
    this.keyboardType,
    this.textCap = TextCapitalization.none,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: textCap,
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(35, 150, 230, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onTap: onTap,
    );
  }
}
