import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wefit/pages/tracksleep.dart';
import '../components/bottom_nav_bar.dart';
import '../components/customcolor.dart';
import 'alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _bedtimeEnabled = false;
  bool _alarmEnabled = false;
  int cupsConsumed = 0;
  int totalCupGoal = 8;
  late Box<AlarmData> _alarmBox;
  AlarmData? _bedtimeAlarm;
  AlarmData? _wakeUpAlarm;
  late Box<int> stepsBox;
  late Box<String> dateBox;
  late Timer _timer;
  //AlarmData? _bedtimeAlarm;
  //AlarmData? _wakeUpAlarm;

  String _currentDay = '';
  Map<String, dynamic> _mealData = {};

  Future<void> _loadMealData() async {
    final jsonString = await rootBundle.loadString('lib/meal/meals.json');
    final jsonData = jsonDecode(jsonString);

    setState(() {
      final dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][DateTime.now().weekday % 7];
      _mealData = jsonData[dayName];
      _currentDay = DateTime.now().toString().split(' ')[0];
    });
  }

  void _incrementCups() {
    setState(() {
      if (cupsConsumed < totalCupGoal) {
        cupsConsumed++;
        stepsBox.put('Cups_consumed', cupsConsumed); // Update in Hive
      }
      if (cupsConsumed == totalCupGoal) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hooray! You Hydrated Yourself')),
        );
      }
    });
  }

  Future<void> _loadAlarms() async {
    if (_alarmBox.isNotEmpty) {
      setState(() {
        _bedtimeAlarm = _alarmBox.get('bedtime');
        _wakeUpAlarm = _alarmBox.get('wakeUp');
        _bedtimeEnabled = _bedtimeAlarm != null;
        _alarmEnabled = _wakeUpAlarm != null;
      });

      // Schedule bedtime notification
      if (_bedtimeEnabled) {
        await _scheduleNotification(
          'Bedtime',
          'It\'s time to sleep!',
          _bedtimeAlarm!.time,
        );
      }

      // Schedule wakeup time notification
      if (_alarmEnabled) {
        await _scheduleNotification(
          'Wakeup Time',
          'Good morning!',
          _wakeUpAlarm!.time,
        );
      }
    }
  }

  Future<void> _scheduleNotification(String title, String message, TimeOfDay time) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      // Schedule for the next day if the time is in the past
      scheduledDate.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }




  void _showSettingsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Total Cup Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (totalCupGoal > 0) totalCupGoal--; // Decrease goal
                        stepsBox.put('Cups_Goal', totalCupGoal); // Update in Hive
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$totalCupGoal'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        totalCupGoal++; // Increase goal
                        stepsBox.put('Cups_Goal', totalCupGoal); // Update in Hive
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('DONE', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _toggleBedtimeAlarm(bool value) {
    setState(() {
      if (_bedtimeAlarm != null) {
        _bedtimeAlarm!.vibrationEnabled = value;
        _alarmBox.put('bedtime', _bedtimeAlarm!);
      }
    });
  }

  void _toggleWakeUpAlarm(bool value) {
    setState(() {
      if (_wakeUpAlarm != null) {
        _wakeUpAlarm!.vibrationEnabled = value;
        _alarmBox.put('wakeUp', _wakeUpAlarm!);
      }
      _alarmEnabled = value;
    });
  }

  Duration _calculateSleepDuration(TimeOfDay bedtime, TimeOfDay alarmTime) {
    final now = DateTime.now();
    final bedTimeToday = DateTime(now.year, now.month, now.day, bedtime.hour, bedtime.minute);
    final alarmTimeToday = DateTime(now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);

    // Adjust for the next day if the alarm time is earlier than the bedtime
    if (alarmTimeToday.isBefore(bedTimeToday)) {
      return alarmTimeToday.add(Duration(days: 1)).difference(bedTimeToday);
    } else {
      return alarmTimeToday.difference(bedTimeToday);
    }
  }






  //_loadAlarms();

  @override
  void initState() {
    super.initState();
    _initHive();
    _scheduleDailyReset();
    _loadAlarms();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    _alarmBox = await Hive.openBox<AlarmData>('alarms');
    stepsBox = await Hive.openBox<int>('steps');
    dateBox = await Hive.openBox<String>('dates');

    // Load initial values from Hive
    setState(() {
      cupsConsumed = stepsBox.get('Cups_consumed', defaultValue: 0)!;
      totalCupGoal = stepsBox.get('Cups_Goal', defaultValue: 8)!;

      // Load alarms from Hive
      _bedtimeAlarm = _alarmBox.get('bedtime');
      _wakeUpAlarm = _alarmBox.get('wakeUp');
      _bedtimeEnabled = _bedtimeAlarm != null;
      _alarmEnabled = _wakeUpAlarm != null;
    });

    _loadMealData();
    _checkAndResetCups();
    _scheduleDailyReset();
  }

  void _checkAndResetCups() {
    final now = DateTime.now();
    final lastResetDate = DateTime.tryParse(dateBox.get("last_reset") ?? '') ?? now.subtract(Duration(days: 1));

    if (now.difference(lastResetDate).inDays >= 1) {
      setState(() {
        cupsConsumed = 0;
        stepsBox.put('Cups_consumed', cupsConsumed);
        dateBox.put('last_reset', now.toIso8601String());
      });
    }
  }


  void _scheduleDailyReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = nextMidnight.difference(now);

    _timer = Timer(timeUntilMidnight, () {
      _checkAndResetCups();
      _scheduleDailyReset(); // Reschedule for the next day
    });
  }



  @override
  void dispose() {
    super.dispose();
    _timer.cancel;

  }




  Widget _buildMealSection(String mealType, Map<String, dynamic> meal) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            decoration: BoxDecoration(
              color: TColor.secondaryColor2,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                if (meal['image'] != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Adjust the corner radius as needed
                    child: Image.asset(
                      meal['image'],
                      //width: 110.0,
                      //height: 110.0,
                      //fit: BoxFit.fill, // Ensure the image fills the available space
                    ),
                  ),
                  /*ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      meal['image'],
                      width: 300,
                      //fit: BoxFit.cover,
                      height: 150,
                      //width: double.infinity,
                    ),
                  ),

                   */
                  SizedBox(height: 8.0),
                ],
                _buildNestedTile('Name', [Text(meal['name'], style: TextStyle(color: Colors.white))]),
                _buildNestedTile(
                  'Ingredients',
                  (meal['ingredients'] as List<dynamic>).map<Widget>((ingredient) => _buildBulletin(ingredient.toString())).toList(),
                ),
                _buildNestedTile(
                  'Instructions',
                  (meal['instructions'] as List<dynamic>).asMap().entries.map((entry) => _buildStepBulletin(entry.key + 1, entry.value.toString())).toList(),
                ),
                _buildNestedTile(
                  'Nutritional Values',
                  (meal['Nutritional Values'] as List<dynamic>).map<Widget>((value) => _buildBulletin(value.toString())).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNestedTile(String title, List<Widget> content) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: TColor.primaryColor1,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildBulletin(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.circle,
            size: 10.0,
            color: Colors.white,
          ),
        ),
        Expanded(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20))),
      ],
    );
  }

  Widget _buildStepBulletin(int step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Text(
            'Step $step:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: _buildBulletin(text)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '             WELLNESS CHECK',
              style: TextStyle(fontWeight: FontWeight.bold),

            ),

            const SizedBox(width: 10,),
            Icon(Icons.favorite, size: 30,),
          ],
        ),
        centerTitle: true,

      ),
      bottomNavigationBar: MyCustomBottomNavBar(initialIndex: 2,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section (Logo, Water Tracker, and Drop Icon)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  // Your app logo or relevant image
                  GestureDetector(
                    onTap: () {
                      // Navigate to the desired screen when the image is tapped.
                      // You can use Navigator.of(context).push() or any other navigation method.
                      // For example:
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SleepPage()),
                      );
                    },
                    child: Image.asset('lib/images/slip.png'),
                  ),

                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Today Schedule',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Bedtime
                        ScheduleItem(
                          icon: Icons.hotel,
                          title: 'Bedtime',
                          time: _bedtimeAlarm != null
                              ? '${_bedtimeAlarm!.time.format(context)}'
                              : 'No alarm set',
                          duration: _bedtimeAlarm != null
                              ? '${_calculateSleepDuration(_bedtimeAlarm!.time, _wakeUpAlarm!.time).inHours} hours ${_calculateSleepDuration(_bedtimeAlarm!.time, _wakeUpAlarm!.time).inMinutes % 60} minutes'
                              : '',
                          isEnabled: _bedtimeEnabled,
                          onChanged: (value) {
                            setState(() {
                              _bedtimeEnabled = value;
                            });
                          },
                        ),
                        //_loadAlarms(),
                        SizedBox(height: 16),
                        // Alarm
                        ScheduleItem(
                          icon: Icons.alarm,
                          title: 'Alarm',
                          time: _wakeUpAlarm != null
                              ? '${_wakeUpAlarm!.time.format(context)}'
                              : 'No alarm set',
                          duration: _wakeUpAlarm != null
                              ? '${_wakeUpAlarm!.sleepDuration.inHours} hours ${_wakeUpAlarm!.sleepDuration.inMinutes % 60} minutes'
                              : '',
                          isEnabled: _alarmEnabled,
                          onChanged: (value) {
                            setState(() {
                              _alarmEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding (
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the second route when the button is pressed.
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlarmScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.secondaryColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Change Schedule',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),



                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop, size: 36),
                          SizedBox(width: 8), // Add spacing between icon and text
                          Text(
                            'Water Tracker',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        onPressed: _showSettingsPopup,
                        icon: Icon(Icons.settings),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                ],
              ),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the corner radius as needed
              child: Image.asset(
                'lib/images/hydrate.png',
                //width: 110.0,
                //height: 110.0,
                fit: BoxFit.fill, // Ensure the image fills the available space
              ),
            ),

            const SizedBox(height: 16),

            // Water Tracker Display (Current consumption and glass icon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$cupsConsumed/$totalCupGoal cups',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.local_drink, size: 28),
                ],
              ),
            ),

            // "+ Drink" Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _incrementCups,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,


                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '+ Drink',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  // Your app logo or relevant image
                  //Image.asset('lib/images/slip.png',),
                  //SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fastfood, size: 36),
                          SizedBox(width: 8), // Add spacing between icon and text
                          Text(
                            'Meal Tracker',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),



                    ],
                  ),

                  SizedBox(height: 8),

                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the corner radius as needed
              child: Image.asset(
                'lib/images/meal.png',

                fit: BoxFit.fill,
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Menu For Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Date: $_currentDay'),
                  SizedBox(height: 16),
                  if (_mealData.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          // Your app logo or relevant image
                          //Image.asset('lib/images/slip.png',),
                          //SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.fastfood, size: 36),
                                  SizedBox(width: 8), // Add spacing between icon and text
                                  Text(
                                    'Breakfast',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),



                            ],
                          ),

                          SizedBox(height: 8),

                        ],
                      ),
                    ),
                    _buildMealSection('Breakfast', _mealData['meals']['breakfast']),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          // Your app logo or relevant image
                          //Image.asset('lib/images/slip.png',),
                          //SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.fastfood, size: 36),
                                  SizedBox(width: 8), // Add spacing between icon and text
                                  Text(
                                    'Lunch',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),



                            ],
                          ),

                          SizedBox(height: 8),

                        ],
                      ),
                    ),
                    _buildMealSection('Lunch', _mealData['meals']['lunch']),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          // Your app logo or relevant image
                          //Image.asset('lib/images/slip.png',),
                          //SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.fastfood, size: 36),
                                  SizedBox(width: 8), // Add spacing between icon and text
                                  Text(
                                    'Dinner',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),



                            ],
                          ),

                          SizedBox(height: 8),

                        ],
                      ),
                    ),
                    _buildMealSection('Dinner', _mealData['meals']['dinner']),
                  ] else ...[
                    Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String duration;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const ScheduleItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.duration,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(time),
            Text(duration),
          ],
        ),
        Spacer(),
        Switch(
          value: isEnabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
