import 'package:flutter/material.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppbarWidget(),
      body: Center(child: Text('Notificaciones'),),
    );
  }
}