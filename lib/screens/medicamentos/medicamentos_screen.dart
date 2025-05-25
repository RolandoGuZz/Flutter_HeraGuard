import 'package:flutter/material.dart';
import 'package:heraguard/services/medicine_service.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';
import 'package:heraguard/screens/screens.dart';

class MedicamentosScreen extends StatefulWidget {
  const MedicamentosScreen({super.key});

  @override
  State<MedicamentosScreen> createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  late Future<List> _medicationsFuture;

  Future<void> _loadMedications() async {
    setState(() {
      _medicationsFuture = MedicineService.getMedications();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

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
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: _medicationsFuture,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final medications = snapshot.data!;
                    return ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medicine = medications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          color: Color.fromRGBO(35, 150, 230, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Nombre: ${medicine['name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit),
                                          color: Colors.amber,
                                          iconSize: 35,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete),
                                          color: Colors.red,
                                          iconSize: 35,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'Dosis: ${medicine['dose']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Duración: ${medicine['durationNumber']} ${medicine['duration']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Frecuencia: ${medicine['frequency']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(35, 150, 230, 1),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarMedicamento()),
              );
              if (result == true) {
                _loadMedications();
              }
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.plus_one, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
