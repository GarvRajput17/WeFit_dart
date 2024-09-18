import 'package:hive/hive.dart';
part 'workout.g.dart';
@HiveType(typeId: 0, adapterName: "MyTypeAdapter1")
class Workout extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int caloriesBurned;

  @HiveField(2)
  int duration; // duration in minutes

  @HiveField(3)
  String imagePath;

  Workout({
    required this.name,
    required this.caloriesBurned,
    required this.duration,
    required this.imagePath,
  });
}