import 'package:flutter/material.dart';
import 'package:heraguard/screens/screens.dart';
import 'package:heraguard/services/appointment_service.dart';
import 'package:heraguard/widgets/sidebar.dart';
import 'package:heraguard/widgets/appbar_widget.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  late Future<List> _appointmentsFuture;
  @override
  void initState() {
    super.initState();
    _appointmentsFuture = AppointmentService.getAppointments();
  }

  void _recargarCitas() {
    setState(() {
      _appointmentsFuture = AppointmentService.getAppointments();
    });
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
            SizedBox(height: 20),
            Text(
              'Citas Médicas',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: _appointmentsFuture,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final appointments = snapshot.data!;
                    return ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: ListTile(
                            title: Text(
                              'Doctor: ${appointment['doctor']}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha: ${appointment['date']}',
                                ),
                                Text(
                                  'Hora: ${appointment['time']}',
                                ),
                                Text(
                                  'Dirección: ${appointment['address']}',
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
                MaterialPageRoute(builder: (context) => AgregarCita()),
              );
              if (result == true) {
                _recargarCitas();
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
