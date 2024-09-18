import 'package:flutter/material.dart';
import 'package:wefit/Workouts/AbsBeg.dart';
import '../../Workouts/AbsInt.dart';
import '../../Workouts/workoutinfo.dart';
import '../../components/rbutton.dart';


class AbsIntPage extends StatelessWidget {
  final List<Exercise7> exercises = [
    Exercise7(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 1),
    Exercise7(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 2),
    Exercise7(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 3),
    Exercise7(name: 'Russian Twist', type: 'reps', reps: 18, imageUrl: 'lib/images/rtwist.png',exerciseidx: 4),
    Exercise7(name: 'Abdominal Crunches', type: 'reps', reps: 18, imageUrl: 'lib/images/abd_crunch.png', exerciseidx: 5),
    Exercise7(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 6),
    Exercise7(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 7),
    Exercise7(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 8),
    //Exercise(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 9),
    Exercise7(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 9),
    Exercise7(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 10),
    Exercise7(name: 'Russian Twist', type: 'reps', reps: 18, imageUrl: 'lib/images/rtwist.png', exerciseidx: 11),
    Exercise7(name: 'Abdominal Crunches', type: 'reps', reps: 18, imageUrl: 'lib/images/abd_crunch.png', exerciseidx: 12),
    Exercise7(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 13),
    Exercise7(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 14),
    Exercise7(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 15),
    Exercise7(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 9),
    Exercise7(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 10),
    Exercise7(name: 'Russian Twist', type: 'reps', reps: 18, imageUrl: 'lib/images/rtwist.png', exerciseidx: 11),
    Exercise7(name: 'Abdominal Crunches', type: 'reps', reps: 18, imageUrl: 'lib/images/abd_crunch.png', exerciseidx: 12),
    Exercise7(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 13),
    Exercise7(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 14),
    Exercise7(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 15),
    Exercise7(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 16),
    //Exercise(name: 'Spine Lumbar Twist Stretch Left', type: 'duration', duration: 30, imageUrl: 'lib/images/left stretch.png', exerciseidx: 17),
    //Exercise(name: 'Spine Lumbar Twist Stretch Right', type: 'duration', duration: 30, imageUrl: 'lib/images/left stretch.png', exerciseidx: 18),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intermediate Abs'),
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
                    Text('29 mins'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.local_fire_department),
                    SizedBox(height: 5),
                    Text('450 Calories'),
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
                WorkoutRoutine7 routine = WorkoutRoutine7(name: "Intermediate Abs", exercises: exercises);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreenLogic7(),
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
  final Exercise7 exercise;

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