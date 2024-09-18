import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../components/rbutton.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final String workoutName;

  const WorkoutDetailsScreen({Key? key, required this.workoutName})
      : super(key: key);

  @override
  _WorkoutDetailsScreenState createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  Map<String, dynamic>? workoutData;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _youtubeController?.pause(); // Ensure the video is paused after the widget builds
    });
  }

  Future<void> _loadWorkoutData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/Workouts/workouts.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    final workout = jsonData.firstWhere(
          (item) => item['name'] == widget.workoutName,
      orElse: () => null,
    );

    setState(() {
      workoutData = workout as Map<String, dynamic>?;
      if (workoutData != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(workoutData!['youtube_link'])!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: true, // Optional
          ),
        );
      }
    });
  }

  Future<void> _openYouTubeApp(String url) async {
    final videoId = YoutubePlayer.convertUrlToId(url);
    final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl);
    } else {
      throw 'Could not launch YouTube';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (workoutData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Details', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VIDEO',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8.0),
              if (_youtubeController != null)
                GestureDetector(
                  onTap: () => _openYouTubeApp(workoutData!['youtube_link']),
                  child: YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              const SizedBox(height: 16.0),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                workoutData!['description'],
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Focus Areas:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: (workoutData!['focus_areas'] as List<dynamic>)
                    .map((area) => Chip(
                  label: Text(area as String),
                  backgroundColor: Colors.blue[100],
                  labelStyle: const TextStyle(fontSize: 16.0),
                ))
                    .toList(),
              ),
              const SizedBox(height: 24.0),
              if (workoutData!['image'] != null)
                Center(
                  child: Image.asset(
                    workoutData!['image'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                    height: MediaQuery.of(context).size.height * 0.3, // Adjust height
                  ),
                ),
              const SizedBox(height: 24.0),
              Center(
                child: RoundButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'Close',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }
}
