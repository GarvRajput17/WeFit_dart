import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
//import 'package:vibration/vibration.dart';
import '../components/customcolor.dart';

class AlarmScreen extends StatefulWidget {
  AlarmScreen({super.key});
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late Box<AlarmData> _alarmBox;
  late TimeOfDay _bedtime;
  late TimeOfDay _alarmTime;
  Duration _sleepDuration = Duration(hours: 8, minutes: 30);
  bool _vibrationEnabled = false;
  List<int> _repeatDays = []; // Mon to Fri

  //@override
  @override
  void initState() {
    super.initState();
    _alarmBox = Hive.box<AlarmData>('alarms');

    // Load bedtime alarm if it exists
    if (_alarmBox.containsKey('bedtime')) {
      final bedtimeAlarm = _alarmBox.get('bedtime')!;
      _bedtime = bedtimeAlarm.time;
      _vibrationEnabled = bedtimeAlarm.vibrationEnabled;
      _repeatDays = bedtimeAlarm.repeatDays;
    } else {
      _bedtime = TimeOfDay(hour: 22, minute: 0); // Default value
    }

    // Load wake-up alarm if it exists
    if (_alarmBox.containsKey('wakeUp')) {
      final wakeUpAlarm = _alarmBox.get('wakeUp')!;
      _alarmTime = wakeUpAlarm.time;
    } else {
      _alarmTime = TimeOfDay(hour: 7, minute: 0); // Default value
    }

    // Calculate initial sleep duration
    _sleepDuration = _calculateSleepDuration(_bedtime, _alarmTime);
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

  void _selectTime(BuildContext context, bool isBedtime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isBedtime ? _bedtime : _alarmTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isBedtime) {
          _bedtime = pickedTime;
        } else {
          _alarmTime = pickedTime;
        }
        _sleepDuration = _calculateSleepDuration(_bedtime, _alarmTime);
      });
    }
  }

  /*void _setSleepDuration(Duration duration) {
    setState(() {
      _sleepDuration = duration;
    });
  }

   */
/*
  void _toggleVibration(bool newValue) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) {
      setState(() {
        _vibrationEnabled = newValue;
      });
    }
  }

 */

  void _setRepeatDays(List<int> days) {
    setState(() {
      _repeatDays = days;
    });
  }

  void _saveAlarm() {
    final AlarmData bedtimeAlarm = AlarmData(
      time: _bedtime,
      sleepDuration: _sleepDuration,
      vibrationEnabled: _vibrationEnabled,
      repeatDays: _repeatDays,
    );
    final AlarmData wakeUpAlarm = AlarmData(
      time: _alarmTime,
      sleepDuration: _sleepDuration,
      vibrationEnabled: _vibrationEnabled,
      repeatDays: _repeatDays,
    );

    // Define the vibration pattern
    List<int> vibrationPattern;
    if (_vibrationEnabled) {
      vibrationPattern = [500, 1000]; // Example vibration pattern
    } else {
      vibrationPattern = []; // No vibration
    }

    // Save the alarms with the vibration pattern
    _alarmBox.put('bedtime', bedtimeAlarm.copyWith(vibrationPattern: vibrationPattern));
    _alarmBox.put('wakeUp', wakeUpAlarm.copyWith(vibrationPattern: vibrationPattern));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Cycle', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bedtime
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text('Bedtime'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('h:mm a').format(
                      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _bedtime.hour, _bedtime.minute),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      _selectTime(context, true);
                    },
                  ),
                ],
              ),
            ),

            // Alarm Time
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Wakeup Time'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('h:mm a').format(
                      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _alarmTime.hour, _alarmTime.minute),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      _selectTime(context, false);
                    },
                  ),
                ],
              ),
            ),

            // Hours of sleep
            ListTile(
              leading: Icon(Icons.hourglass_empty),
              title: Text('Hours of sleep'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_calculateSleepDuration(_bedtime, _alarmTime).inHours}:${_calculateSleepDuration(_bedtime, _alarmTime).inMinutes.remainder(60).toString().padLeft(2, '0')}',
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Set Sleep Duration'),
                            content: DurationPicker(
                              duration: _sleepDuration,
                              onDurationChanged: (newDuration) {
                                setState(() {
                                  _sleepDuration = newDuration;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),


            // Repeat


            // Vibrate

            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: _saveAlarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Customize button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}



// Model for alarm data
class AlarmData {
  final TimeOfDay time;
  final Duration sleepDuration;
  late final bool vibrationEnabled;
  final List<int> repeatDays;
  final String soundName;
  List<int>? vibrationPattern;

  AlarmData({
    required this.time,
    required this.sleepDuration,
    required this.vibrationEnabled,
    required this.repeatDays,
    this.soundName = 'Ringtone', List<int>? vibrationPattern,
  });

  AlarmData copyWith({
    TimeOfDay? time,
    Duration? sleepDuration,
    bool? vibrationEnabled,
    List<int>? repeatDays,
    String? soundName,
    List<int>? vibrationPattern,
  }) {
    return AlarmData(
      time: time ?? this.time,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
      soundName: soundName ?? this.soundName,
      vibrationPattern: vibrationPattern ?? this.vibrationPattern,
    );
  }
}
// Adapter for Hive
class AlarmDataAdapter extends TypeAdapter<AlarmData> {
  @override
  final int typeId = 0;

  @override
  AlarmData read(BinaryReader reader) {
    final timeHour = reader.readByte();
    final timeMinute = reader.readByte();
    final sleepDurationHours = reader.readByte();
    final sleepDurationMinutes = reader.readByte();
    final vibrationEnabled = reader.readBool();
    final repeatDaysLength = reader.readByte();
    final repeatDays = List<int>.generate(
      repeatDaysLength,
          (index) => reader.readByte(),
    );

    return AlarmData(
      time: TimeOfDay(hour: timeHour, minute: timeMinute),
      sleepDuration: Duration(hours: sleepDurationHours, minutes: sleepDurationMinutes),
      vibrationEnabled: vibrationEnabled,
      repeatDays: repeatDays,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmData obj) {
    writer.writeByte(obj.time.hour);
    writer.writeByte(obj.time.minute);
    writer.writeByte(obj.sleepDuration.inHours);
    writer.writeByte(obj.sleepDuration.inMinutes.remainder(60));
    writer.writeBool(obj.vibrationEnabled);
    writer.writeByte(obj.repeatDays.length);
    for (final day in obj.repeatDays) {
      writer.writeByte(day);
    }
  }
}

// Duration Picker
class DurationPicker extends StatefulWidget {
  final Duration duration;
  final void Function(Duration) onDurationChanged;

  const DurationPicker({
    Key? key,
    required this.duration,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    _hours = widget.duration.inHours;
    _minutes = widget.duration.inMinutes.remainder(60);
  }

  void _updateDuration() {
    widget.onDurationChanged(Duration(hours: _hours, minutes: _minutes));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('Hours:'),
            SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: TextFormField(
                initialValue: _hours.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _hours = int.tryParse(value) ?? 0;
                    _updateDuration();
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Minutes:'),
            SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: TextFormField(
                initialValue: _minutes.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _minutes = int.tryParse(value) ?? 0;
                    _updateDuration();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Repeat Days Picker
class RepeatDaysPicker extends StatefulWidget {
  final List<int> selectedDays;
  final void Function(List<int>) onDaysChanged;

  const RepeatDaysPicker({
    Key? key,
    required this.selectedDays,
    required this.onDaysChanged,
  }) : super(key: key);

  @override
  _RepeatDaysPickerState createState() => _RepeatDaysPickerState();
}

class _RepeatDaysPickerState extends State<RepeatDaysPicker> {
  final List<String> _dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        _dayLabels.length,
            (index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              label: Text(_dayLabels[index]),
              selected: widget.selectedDays.contains(index),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    widget.selectedDays.add(index);
                  } else {
                    widget.selectedDays.remove(index);
                  }
                  widget.onDaysChanged(widget.selectedDays);
                });
              },
            ),
          );
        },
      ),
    );
  }
}