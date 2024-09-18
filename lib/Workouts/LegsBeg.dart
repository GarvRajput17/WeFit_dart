import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

import '../components/rbutton.dart';
import '../pages/RestPage.dart';
import '../pages/WorkoutFinish.dart';
import '../pages/warmup.dart';

class WorkoutScreenLogic2 extends StatefulWidget {
  @override
  _WorkoutScreenLogic2 createState() => _WorkoutScreenLogic2();
}

class _WorkoutScreenLogic2 extends State<WorkoutScreenLogic2> {
  WorkoutRoutine2? routine;
  int currentExerciseIndex = 0;
  Timer? _timer;
  int remainingTime = 0;
  int totalTime = 0;
  bool isPaused = false;
  bool isResting = false;
  int? _level;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (routine != null) {
        startWarmUp();
      }
    });
  }

  void startWarmUp() async {
    final warmUpFinished = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WarmUpScreen()),
    );
    if (warmUpFinished == true) {
      startExercise();
    }
  }

  void startExercise() {
    final currentExercise = routine!.exercises[currentExerciseIndex];
    if (currentExercise.type == "duration") {
      remainingTime = currentExercise.duration;
      totalTime = currentExercise.duration;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!isPaused) {
          setState(() {
            if (remainingTime > 0) {
              remainingTime--;
            } else {
              timer.cancel();
              startRest();
            }
          });
        }
      });
    } else if (currentExercise.type == "reps") {
      // Handle reps-based exercise without a timer
      setState(() {
        remainingTime = 0;
        totalTime = 0;
      });
    }
  }

  void startRest() async {
    setState(() {
      isResting = true;
    });
    final restFinished = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RestScreen()),
    );
    if (restFinished == true) {
      nextExercise();
    }
  }

  void nextExercise() {
    if (currentExerciseIndex < routine!.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        isResting = false;
      });
      startExercise();
    } else {
      Box profileBox = Hive.box('profileBox');
      _level = profileBox.get('level');
      profileBox.put('level', _level! + 1);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkoutFinish()),
      );
    }
  }

  void previousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
        isPaused = false;
      });
      startExercise();
    }
  }

  void pauseExercise() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void skipExercise() {
    _timer?.cancel();
    if (routine!.exercises[currentExerciseIndex].type == "reps") {
      // If the current exercise is of type "reps", initiate rest period after skipping
      startRest();
    } else {
      nextExercise();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    routine = ModalRoute.of(context)!.settings.arguments as WorkoutRoutine2?;

    if (routine == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Workout")),
        body: Center(child: Text("No workout routine provided")),
      );
    }

    final currentExercise = routine!.exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(title: Text(routine!.name)),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exercise name
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  isResting ? "Rest" : currentExercise.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Exercise image
            if (!isResting && currentExercise.type == "reps")
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentExercise.imageUrl),
                  ),
                ),
              ),
            if (currentExercise.type == "duration")
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentExercise.imageUrl),
                  ),
                ),
              ),
            SizedBox(height: 20),
            // Circular Timer for duration exercises
            if (currentExercise.type == "duration")
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 10.0,
                percent: (totalTime - remainingTime) / totalTime,
                center: Text("$remainingTime s", style: TextStyle(fontSize: 20)),
                progressColor: Colors.blue,
              ),
            if (currentExercise.type == "reps")
              Text("${currentExercise.reps} reps", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            // Buttons
            if (!isResting && currentExercise.type == "duration")
              RoundButton(
                title: isPaused ? "Resume" : "Pause",
                onPressed: pauseExercise,
              ),
            if (isResting)
              RoundButton(
                title: "Skip Rest",
                onPressed: skipExercise,
              ),
            SizedBox(height: 20),
            RoundButton(
              title: "Skip Exercise",
              onPressed: skipExercise,
            ),
            if (!isResting && currentExercise.type == "reps")
              SizedBox(height: 20),
            if (!isResting && currentExercise.type == "reps")
              RoundButton(
                title: "Next",
                onPressed: startRest,
              ),
          ],
        ),
      ),
    );
  }
}


class Exercise2 {
  final String name;
  final String type; // "duration" or "reps"
  final int duration; // in seconds
  final int reps; // for exercises with reps
  final String imageUrl;
  final int exerciseidx;

  Exercise2({
    required this.name,
    required this.type,
    this.duration = 0,
    this.reps = 0,
    required this.imageUrl,
    required this.exerciseidx,
  });
}

class WorkoutRoutine2 {
  final String name;
  final List<Exercise2> exercises;

  WorkoutRoutine2({required this.name, required this.exercises});
}

List<WorkoutRoutine2> WorkoutRoutine2s = [
  WorkoutRoutine2(
    name: "Beginner Legs",
    exercises: [
      Exercise2(
        name: "Jumping Jacks",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/Jacks.png",
        exerciseidx: 1,
      ),
      Exercise2(
        name: "Squats",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/squats.png",
        exerciseidx: 2,
      ),
      Exercise2(
        name: "Forward Lunge",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 3,
      ),
      Exercise2(
        name: "Backward Lunge",
        type: "reps",
        duration: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 4,
      ),
      Exercise2(
        name: "Lateral Leg Raises",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/legraises.png",
        exerciseidx: 5,
      ),
      Exercise2(
        name: "High Stepping",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/highknee.png",
        exerciseidx: 6,
      ),
      Exercise2(
        name: "Toe Touch",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/toetouch.png",
        exerciseidx: 7,
      ),
      Exercise2(
        name: "Leg Raises",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/legraises.png",
        exerciseidx: 8,
      ),
      Exercise2(
        name: "Wall Sit",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/wallsit.png",
        exerciseidx: 9,
      ),
      Exercise2(
        name: "Jumping Jacks",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/Jacks.png",
        exerciseidx: 10,
      ),
      Exercise2(
        name: "Squats",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/squats.png",
        exerciseidx: 11,
      ),
      Exercise2(
        name: "Forward Lunge",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 12,
      ),
      Exercise2(
        name: "Backward Lunge",
        type: "reps",
        duration: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 13,
      ),
      Exercise2(
        name: "Lateral Leg Raises",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/legraises.png",
        exerciseidx: 14,
      ),
      Exercise2(
        name: "High Stepping",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/highknee.png",
        exerciseidx: 15,
      ),
      Exercise2(
        name: "Toe Touch",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/toetouch.png",
        exerciseidx: 16,
      ),
      Exercise2(
        name: "Leg Raises",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/legraises.png",
        exerciseidx: 17,
      ),
      Exercise2(
        name: "Wall Sit",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/wallsit.png",
        exerciseidx: 18,
      ),
      Exercise2(
        name: "Squats",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/squats.png",
        exerciseidx: 19,
      ),
      Exercise2(
        name: "Forward Lunge",
        type: "reps",
        reps: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 20,
      ),
      Exercise2(
        name: "Backward Lunge",
        type: "reps",
        duration: 14,
        imageUrl: "lib/images/lunge.png",
        exerciseidx: 21,
      ),
      Exercise2(
        name: "Lateral Leg Raises",
        type: "reps",
        duration: 18,
        imageUrl: "lib/images/legraises.png",
        exerciseidx: 22,
      ),

      Exercise2(
        name: "Cobra Stretch",
        type: "duration",
        duration: 30,
        imageUrl: "lib/images/cobrast.png",
        exerciseidx: 23,
      ),



    ],
  ),
  // Add more routines as needed
];
