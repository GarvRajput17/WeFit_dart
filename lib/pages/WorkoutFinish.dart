import 'package:flutter/material.dart';

import '../components/customcolor.dart';
import '../components/rbutton.dart';

class WorkoutFinish extends StatefulWidget {
  WorkoutFinish({super.key});

  @override
  State<WorkoutFinish> createState() => _WorkoutFinishState();
}

class _WorkoutFinishState extends State<WorkoutFinish> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              Image.asset(
                "assets/img/complete_workout.png",
                height: media.width * 0.8,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(height: 20,),
              Text(
                "Congratulations, You Have Finished Your Workout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                "Check out Other exercise so that\n You can train your whole body in proper proportions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8,),

              const Spacer(),
              RoundButton(
                  title: "Back To Home",
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
