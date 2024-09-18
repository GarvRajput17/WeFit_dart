import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wefit/components/rbutton.dart';
import 'package:wefit/pages/homepage1.dart';

class RestScreen extends StatefulWidget {
  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  Timer? _timer;
  int remainingTime = 30;
  bool isPaused = false;
  int additionalRestTime = 0;

  @override
  void initState() {
    super.initState();
    startRest();
  }

  void startRest() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            timer.cancel();
            Navigator.pop(context, true); // Indicate rest finished
          }
        });
      }
    });
  }
  void _navigateBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage1 with your desired page widget
    );
  }


  void pauseRest() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void increaseRestTime() {
    setState(() {
      additionalRestTime += 20;
      remainingTime += 20;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalRestTime = 30 + additionalRestTime;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rest"),
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
              "Rest",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: (totalRestTime - remainingTime) / totalRestTime,
              center: Text("$remainingTime s", style: TextStyle(fontSize: 20)),
              progressColor: Colors.blue,
            ),
            SizedBox(height: 20),
            RoundButton(
              onPressed: pauseRest,
              title: isPaused ? "Resume" : "Pause",
            ),
            SizedBox(height: 20),
            RoundButton(
              onPressed: increaseRestTime,
              title: "Add 20 Seconds",
            ),
          ],
        ),
      ),
    );
  }

}