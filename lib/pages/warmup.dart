import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wefit/pages/homepage1.dart';

class WarmUpScreen extends StatefulWidget {
  @override
  _WarmUpScreenState createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<WarmUpScreen> {
  Timer? _timer;
  int remainingTime = 30;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    startWarmUp();
  }

  void startWarmUp() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            timer.cancel();
            Navigator.pop(context, true); // Indicate warm-up finished
          }
        });
      }
    });
  }

  void pauseWarmUp() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage1 with your target page widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warm Up"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Warm-up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/exercise.gif"),
                ),
              ),
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: (30 - remainingTime) / 30,
              center: Text("$remainingTime s", style: TextStyle(fontSize: 20)),
              progressColor: Colors.blue,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pauseWarmUp,
              child: Text(isPaused ? "Resume" : "Pause"),
            ),
          ],
        ),
      ),
    );
  }
}
