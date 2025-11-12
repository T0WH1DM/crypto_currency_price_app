import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home_screen.dart';

void main() {
  runApp(Aplication());
}

class Aplication extends StatefulWidget {
  const Aplication({super.key});

  @override
  State<Aplication> createState() => _AplicationState();
}

class _AplicationState extends State<Aplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
