import 'package:flutter/material.dart';
import 'package:heraguard/widgets/appbar_widget.dart';

class AgregarMedicamento extends StatelessWidget {
  const AgregarMedicamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Agregar Tratamiento',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
