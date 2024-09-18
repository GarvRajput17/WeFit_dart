import 'package:flutter/material.dart';
import 'package:wefit/Workouts/AbsBeg.dart';
import '../../Workouts/ArmAdv.dart';
import '../../Workouts/workoutinfo.dart';
import '../../components/rbutton.dart';


class ArmAdvPage extends StatelessWidget {
  final List<Exercise12> exercises = [
    Exercise12(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 1),
    Exercise12(name: 'Arm Stretch', type: 'reps', reps: 10, imageUrl: 'lib/images/armstretch.png', exerciseidx: 2),
    Exercise12(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 3),
    Exercise12(name: 'Arm Swing', type: 'reps', reps: 18, imageUrl: 'lib/images/armswing.png', exerciseidx: 4),
    Exercise12(name: 'DiamondPushup', type: 'reps', reps: 18, imageUrl: 'lib/images/diamondpushup.png', exerciseidx: 5),
    Exercise12(name: 'In and Out', type: 'duration', duration: 30, imageUrl: 'lib/images/in_out.png', exerciseidx: 6),
    Exercise12(name: 'Elbow Pushup', type: 'reps', reps: 18, imageUrl: 'lib/images/elbowpushup.png', exerciseidx: 7),
    Exercise12(name: 'Inchworms', type: 'reps', reps: 18, imageUrl: 'lib/images/inchworms.png', exerciseidx: 8),
    Exercise12(name: 'Incline Pushups', type: 'reps', reps: 18, imageUrl: 'lib/images/incpushups.png', exerciseidx: 9),
    Exercise12(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 10),
    Exercise12(name: 'Arm Stretch', type: 'reps', reps: 10, imageUrl: 'lib/images/armstretch.png', exerciseidx: 11),
    Exercise12(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 12),
    Exercise12(name: 'Arm Swing', type: 'reps', reps: 18, imageUrl: 'lib/images/armswing.png', exerciseidx: 13),
    Exercise12(name: 'DiamondPushup', type: 'reps', reps: 18, imageUrl: 'lib/images/diamondpushup.png', exerciseidx: 14),
    Exercise12(name: 'In and Out', type: 'duration', duration: 30, imageUrl: 'lib/images/in_out.png', exerciseidx: 15),
    Exercise12(name: 'Elbow Pushup', type: 'reps', reps: 18, imageUrl: 'lib/images/elbowpushup.png', exerciseidx: 16),
    Exercise12(name: 'Inchworms', type: 'reps', reps: 18, imageUrl: 'lib/images/inchworms.png', exerciseidx: 17),
    Exercise12(name: 'Incline Pushups', type: 'reps', reps: 18, imageUrl: 'lib/images/incpushups.png', exerciseidx: 18),
    Exercise12(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 19),
    Exercise12(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 20),
    Exercise12(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 21),
    Exercise12(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 22),
    Exercise12(name: 'Russian Twist', type: 'reps', reps: 18, imageUrl: 'lib/images/rtwist.png', exerciseidx: 23),
    Exercise12(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 24),
    Exercise12(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 25),
    Exercise12(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 26),
    Exercise12(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 27),
    Exercise12(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 28),

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
                    Text('32 mins'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_fire_department),
                    SizedBox(height: 5),
                    Text('525 Calories'),
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
                WorkoutRoutine12 routine = WorkoutRoutine12(name: "Advanced Arm", exercises: exercises);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreenLogic12(),
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
  final Exercise12 exercise;

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