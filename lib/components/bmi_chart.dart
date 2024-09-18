import 'package:flutter/material.dart';

class BmiChart extends StatefulWidget {
  BmiChart({super.key});

  @override
  State<BmiChart> createState() => _BmiChartState();
}
class _BmiChartState extends State<BmiChart> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome Back,',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text('User', style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: media.width * 0.05,)
            ],
          ),
        ),
      ),
    );
  }
}

