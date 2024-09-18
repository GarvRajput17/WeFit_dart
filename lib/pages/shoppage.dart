import 'package:flutter/material.dart';
import 'package:wefit/components/customcolor.dart';
import '../components/bottom_nav_bar.dart';
import '../components/steppaint.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:fl_chart/fl_chart.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _stepCount = 0;
  int _stepGoal = 1000;
  DateTime _dateTime = DateTime.now();
  Timer? _timer;
  Box<int>? stepsBox;
  Box<int>? settingsBox;
  StreamSubscription<StepCount>? _stepSubscription;

  final List<int> _stepGoals = [
    1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000,
    20000, 25000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000
  ];

  @override
  void initState() {
    super.initState();
    _openBoxes();
    _startStepCountStream();
  }

  Future<void> _openBoxes() async {
    stepsBox = await Hive.openBox<int>('stepsBox');
    settingsBox = await Hive.openBox<int>('settingsBox');

    // Load step goal from Hive
    setState(() {
      _stepGoal = settingsBox?.get('stepGoal', defaultValue: 1000) ?? 1000;
    });
  }

  void _startStepCountStream() {
    _stepSubscription = Pedometer.stepCountStream.listen((event) {
      final int stepCount = event.steps ?? 0;
      // Implement a filter to ignore sudden jumps
      if (stepCount > 0 && (stepCount - _stepCount).abs() < 1000) {
        setState(() {
          _stepCount = stepCount;
        });
        _updateMetrics();
      }
    });
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_dateTime.day != DateTime.now().day) {
        setState(() {
          _saveSteps();
          _stepCount = 0;
          _dateTime = DateTime.now();
        });
      }
    });
  }


  void _updateMetrics() {
    setState(() {});
  }

  void _saveSteps() {
    final today = DateFormat('yyyy-MM-dd').format(_dateTime);
    stepsBox?.put(today, _stepCount);
  }

  void _updateStepGoal(int newGoal) {
    setState(() {
      _stepGoal = newGoal;
    });
    settingsBox?.put('stepGoal', _stepGoal);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stepSubscription?.cancel();
    super.dispose();
  }

  double get _calories => _stepCount * 0.04; // Approximate calories burned per step
  double get _distance => _stepCount * 0.0008; // Approximate distance in kilometers per step
  double get _walkingTime => _stepCount / 100; // Approximate walking time in minutes

  List<BarChartGroupData> _createSampleData() {
    final data = <BarChartGroupData>[];
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dayString = DateFormat('yyyy-MM-dd').format(day);
      final steps = stepsBox?.get(dayString) ?? 0;
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: steps.toDouble(),
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreenAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PEDOMETER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: MyCustomBottomNavBar(initialIndex: 1),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(_dateTime)}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Time: ${DateFormat('kk:mm').format(_dateTime)}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.5, // Use SizedBox to constrain width
                  height: 100,
                  child: CustomPaint(
                    painter: StepProgressPainter(_stepCount, _stepGoal),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '$_stepCount / $_stepGoal steps',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Text(
                    'Choose Your Goal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: DropdownButton<int>(
                      value: _stepGoal,
                      items: _stepGoals.map((goal) {
                        return DropdownMenuItem<int>(
                          value: goal,
                          child: Text(
                            '$goal steps',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _updateStepGoal(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.red, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        '${_calories.toStringAsFixed(2)} kcal',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.directions_walk, color: Colors.blue, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        '${_distance.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.timer, color: Colors.green, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        '${_walkingTime.toStringAsFixed(2)} min',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Weekly Report',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300, // Fixed height for the chart
                child: BarChart(
                  BarChartData(
                    barGroups: _createSampleData(),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const style = TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                            switch (value.toInt()) {
                              case 0:
                                return Text('Mon', style: style);
                              case 1:
                                return Text('Tue', style: style);
                              case 2:
                                return Text('Wed', style: style);
                              case 3:
                                return Text('Thu', style: style);
                              case 4:
                                return Text('Fri', style: style);
                              case 5:
                                return Text('Sat', style: style);
                              case 6:
                                return Text('Sun', style: style);
                              default:
                                return Text('', style: style);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
