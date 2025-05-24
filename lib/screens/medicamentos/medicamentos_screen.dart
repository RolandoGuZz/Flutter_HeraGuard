import 'package:flutter/material.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';
import 'package:heraguard/screens/screens.dart';

class MedicamentosScreen extends StatelessWidget {
  const MedicamentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppbarWidget(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Medicamentos',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed:
                () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarMedicamento(),
                    ),
                  ),
                },
            backgroundColor: Colors.green,
            child: Icon(Icons.plus_one, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
