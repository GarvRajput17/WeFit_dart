import 'package:flutter/material.dart';
import 'package:wefit/Workouts/AbsBeg.dart';
import '../../Workouts/LegsAdv.dart';
import '../../Workouts/workoutinfo.dart';
import '../../components/rbutton.dart';


class LegsAdvPage extends StatelessWidget {
  final List<Exercise11> exercises = [
    Exercise11(name: 'Jumping Jacks', type: 'duration', duration: 30, imageUrl: 'lib/images/Jacks.png', exerciseidx: 1),
    Exercise11(name: 'Squats', type: 'reps', reps: 14, imageUrl: 'lib/images/squats.png', exerciseidx: 2),
    Exercise11(name: 'Forward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 3),
    Exercise11(name: 'Backward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 4),
    Exercise11(name: 'Lateral Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 5),
    Exercise11(name: 'High Stepping', type: 'duration', duration: 30, imageUrl: 'lib/images/highknee.png', exerciseidx: 6),
    Exercise11(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 7),
    Exercise11(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 8),
    Exercise11(name: 'Wall Sit', type: 'duration', duration: 30, imageUrl: 'lib/images/wallsit.png', exerciseidx: 9),
    Exercise11(name: 'Push Ups', type: 'reps', reps: 10, imageUrl: 'lib/images/pushups.png', exerciseidx: 10),
    Exercise11(name: 'Plank', type: 'duration', duration: 30, imageUrl: 'lib/images/plank.png', exerciseidx: 11),
    Exercise11(name: 'Russian Twist', type: 'reps', reps: 18, imageUrl: 'lib/images/rtwist.png', exerciseidx: 12),
    Exercise11(name: 'Abdominal Crunches', type: 'reps', reps: 18, imageUrl: 'lib/images/abd_crunch.png', exerciseidx: 13),
    Exercise11(name: 'Mountain Climber', type: 'duration', duration: 30, imageUrl: 'lib/images/mclimber.png', exerciseidx: 14),
    Exercise11(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 15),
    Exercise11(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 16),
    Exercise11(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 17),
    Exercise11(name: 'Squats', type: 'reps', reps: 14, imageUrl: 'lib/images/squats.png', exerciseidx: 18),
    Exercise11(name: 'Forward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 19),
    Exercise11(name: 'Backward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 20),
    Exercise11(name: 'Lateral Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 21),
    Exercise11(name: 'High Stepping', type: 'duration', duration: 30, imageUrl: 'lib/images/highknee.png', exerciseidx: 22),
    Exercise11(name: 'Toe Touch', type: 'reps', reps: 18, imageUrl: 'lib/images/toetouch.png', exerciseidx: 23),
    Exercise11(name: 'Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 24),
    Exercise11(name: 'Wall Sit', type: 'duration', duration: 30, imageUrl: 'lib/images/wallsit.png', exerciseidx: 25),
    Exercise11(name: 'Squats', type: 'reps', reps: 14, imageUrl: 'lib/images/squats.png', exerciseidx: 26),
    Exercise11(name: 'Forward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 27),
    Exercise11(name: 'Backward Lunge', type: 'reps', reps: 14, imageUrl: 'lib/images/lunge.png', exerciseidx: 28),
    Exercise11(name: 'Lateral Leg Raises', type: 'reps', reps: 18, imageUrl: 'lib/images/legraises.png', exerciseidx: 29),
    Exercise11(name: 'Cobra Stretch', type: 'duration', duration: 30, imageUrl: 'lib/images/cobrast.png', exerciseidx: 30),
    //Exercise(name: 'Spine Lumbar Twist Stretch Left', type: 'duration', duration: 30, imageUrl: 'lib/images/left stretch.png', exerciseidx: 17),
    //Exercise(name: 'Spine Lumbar Twist Stretch Right', type: 'duration', duration: 30, imageUrl: 'lib/images/left stretch.png', exerciseidx: 18),
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
                    Text('53 mins'),
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
                WorkoutRoutine11 routine = WorkoutRoutine11(name: "Advanced Legs", exercises: exercises);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreenLogic11(),
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
  final Exercise11 exercise;

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