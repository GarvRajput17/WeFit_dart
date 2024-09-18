import 'package:hive/hive.dart';

part 'alarm_data.g.dart';

@HiveType(typeId: 0)
class AlarmData extends HiveObject {
  @HiveField(0)
  bool bedtimeEnabled;

  @HiveField(1)
  bool alarmEnabled;

  @HiveField(2)
  int cupsConsumed;

  @HiveField(3)
  int totalCupGoal;

  @HiveField(4)
  DateTime lastUpdated;

  AlarmData({
    required this.bedtimeEnabled,
    required this.alarmEnabled,
    this.cupsConsumed = 0,
    this.totalCupGoal = 8,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}