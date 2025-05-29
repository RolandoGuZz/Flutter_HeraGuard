import 'package:flutter/material.dart';
import 'package:heraguard/services/notification_service.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  Future<void> _sendNotification(BuildContext context) async {
    try {
      // Solicitar permisos
      await NotificationService.requestPermissions();
      
      // Enviar noti
      await NotificationService.showImmediateNotification(
        title: "¡Prueba exitosa!",
        body: "Tu notificación funciona correctamente",
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Notificación enviada!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: const AppbarWidget(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _sendNotification(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            "Enviar Notificación",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}