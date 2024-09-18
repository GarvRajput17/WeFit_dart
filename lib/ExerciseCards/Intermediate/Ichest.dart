import 'package:flutter/material.dart';
import 'package:wefit/Workouts/AbsBeg.dart';
import '../../Workouts/ChestInt.dart';
import '../../Workouts/workoutinfo.dart';
import '../../components/rbutton.dart';


class ChestIntpage extends StatelessWidget {
  final List<Exercise5> exercises = [
    Exercise5(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 1),
    Exercise5(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 2),
    Exercise5(name: 'Wall Push Ups', type: 'reps', reps: 14, imageUrl: 'lib/images/wallpushup.png', exerciseidx: 3),
    Exercise5(name: 'Elbow Push Ups', type: 'reps', reps: 14, imageUrl: 'lib/images/elbowpushup.png', exerciseidx: 4),
    Exercise5(name: 'Inchworms', type: 'reps', reps: 6, imageUrl: 'lib/images/inchworms.png', exerciseidx: 5),
    Exercise5(name: 'Pull Ups', type: 'duration', duration: 30, imageUrl: 'lib/images/pullups.png', exerciseidx: 6),
    Exercise5(name: 'Wall Pushes', type: 'reps', reps: 18, imageUrl: 'lib/images/wallpush.png', exerciseidx: 7),
    Exercise5(name: 'Spiderman Push Ups', type: 'reps', reps: 18, imageUrl: 'lib/images/spidermanpushup.png', exerciseidx: 8),
    Exercise5(name: 'Wide Push Ups', type: 'reps', reps: 18, imageUrl: 'lib/images/widepushup.png', exerciseidx: 9),
    Exercise5(name: 'Push Claps', type: 'reps', reps: 18, imageUrl: 'lib/images/pushclaps.png', exerciseidx: 10),
    Exercise5(name: 'Diamond Push Ups', type: 'reps', reps: 15, imageUrl: 'lib/images/diamondpushups.png', exerciseidx: 11),
    Exercise5(name: 'Chest Dips', type: 'reps', reps: 12, imageUrl: 'lib/images/chestdips.png', exerciseidx: 12),
    Exercise5(name: 'Decline Push Ups', type: 'reps', reps: 12, imageUrl: 'lib/images/declinepushups.png', exerciseidx: 13),
    Exercise5(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 14),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'lib/images/Ab-Workout 1.png', // Replace with your main image asset
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.fitness_center),
                    SizedBox(height: 5),
                    Text('${exercises.length} Exercises'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timer),
                    SizedBox(height: 5),
                    Text('15 mins'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_fire_department),
                    SizedBox(height: 5),
                    Text('350 Calories'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Exercise List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseTile(exercise: exercises[index]);
                },
              ),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'Start',
              onPressed: () {
                WorkoutRoutine5 routine = WorkoutRoutine5(name: "Intermediate Chest", exercises: exercises);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreenLogic5(),
                    settings: RouteSettings(arguments: routine),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise5 exercise;

  ExerciseTile({required this.exercise});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(workoutName: exercise.name,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              exercise.imageUrl,
              height: 50,
              width: 50,
            ),
            SizedBox(width: 20),
            Text(
              exercise.name,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}