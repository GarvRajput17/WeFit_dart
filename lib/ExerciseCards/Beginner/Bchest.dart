import 'package:flutter/material.dart';
import 'package:wefit/Workouts/AbsBeg.dart';
import '../../Workouts/ChestBeg.dart';
import '../../Workouts/workoutinfo.dart';
import '../../components/rbutton.dart';


class ChestBegpage extends StatelessWidget {
  final List<Exercise3> exercises = [
    Exercise3(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 1),
    Exercise3(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 2),
    Exercise3(name: 'Wall Push Ups', type: 'reps', reps: 14, imageUrl: 'lib/images/wallpushup.png', exerciseidx: 3),
    Exercise3(name: 'Elbow Push Ups', type: 'reps', reps: 14, imageUrl: 'lib/images/elbowpushup.png', exerciseidx: 4), // Verify spelling 'backstretch.png'
    Exercise3(name: 'Inchworms', type: 'reps', reps: 6, imageUrl: 'lib/images/inchworms.png', exerciseidx: 5),
    Exercise3(name: 'Pull Ups', type: 'duration', duration: 30, imageUrl: 'lib/images/pullups.png', exerciseidx: 6),
    Exercise3(name: 'Wall Pushes', type: 'reps', reps: 18, imageUrl: 'lib/images/wallpush.png', exerciseidx: 7),
    Exercise3(name: 'Spiderman Push Ups', type: 'reps', reps: 18, imageUrl: 'lib/images/spidermanpushup.png', exerciseidx: 8), // Updated name
    Exercise3(name: 'Wide Push Ups', type: 'reps', reps: 18, imageUrl: 'lib/images/widepushup.png', exerciseidx: 9), // Updated name
    Exercise3(name: 'Push Claps', type: 'reps', reps: 18, imageUrl: 'lib/images/pushclaps.png', exerciseidx: 10),
    Exercise3(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 11),
    // Uncomment and update the names based on JSON
    // Exercise3(name: 'Left Side Lumbar Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/left_stretch.png', exerciseidx: 17),
    // Exercise3(name: 'Right Side Lumbar Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/right_stretch.png', exerciseidx: 18),
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
                    Text('11 mins'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_fire_department),
                    SizedBox(height: 5),
                    Text('200 Calories'),
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
                WorkoutRoutine3 routine = WorkoutRoutine3(name: "Beginner Chest", exercises: exercises);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreenLogic3(),
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
  final Exercise3 exercise;

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