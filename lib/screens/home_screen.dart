import 'package:flutter/material.dart';
import 'package:heraguard/widgets/appbar_widget.dart';
import 'package:heraguard/widgets/sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: Sidebar(), appBar: AppbarWidget());
  }
}
