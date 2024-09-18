// lib/armbeg.dart

import 'package:flutter/material.dart';

class ShoulderBegPage extends StatefulWidget {
  @override
  _ShoulderBegPageState createState() => _ShoulderBegPageState();
}

class _ShoulderBegPageState extends State<ShoulderBegPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arm Beginner Exercises'),
      ),
      body: Center(
        child: Text('Your arm exercise content goes here.'),
      ),
    );
  }
}
