import 'package:flutter/material.dart';

class WorkoutHistory {
  static List<Map<String, dynamic>> _workoutHistory = [];

  static void addWorkoutToHistory(String workoutName, int caloriesBurned, int duration) {
    _workoutHistory.add({
      'workoutName': workoutName,
      'caloriesBurned': caloriesBurned,
      'duration': duration,
    });
  }

  static List<Map<String, dynamic>> getWorkoutHistory() {
    return _workoutHistory;
  }

  static void clearWorkoutHistory() {
    _workoutHistory.clear();
  }
}

class WorkoutHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Clear Workout History'),
                    content: Text('Are you sure you want to clear your workout history?'),
                    actions: [
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () {
                          WorkoutHistory.clearWorkoutHistory();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Workout history cleared')),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: WorkoutHistory.getWorkoutHistory().length,
        itemBuilder: (context, index) {
          final workoutData = WorkoutHistory.getWorkoutHistory()[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workoutData['workoutName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Calories Burned:'),
                          Text(
                            '${workoutData['caloriesBurned']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration:'),
                          Text(
                            '${workoutData['duration']} minutes',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}