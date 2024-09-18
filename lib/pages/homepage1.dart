import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
import 'package:wefit/ExerciseCards/Advanced/Alegs.dart';
import 'package:wefit/components/customcolor.dart';
import 'package:wefit/pages/quotes.dart';
import '../ExerciseCards/Advanced/Aabs.dart';
import '../ExerciseCards/Advanced/Aarm.dart';
import '../ExerciseCards/Advanced/Achest.dart';
import '../ExerciseCards/Beginner/Babs.dart';
import '../ExerciseCards/Beginner/Barm.dart';
import '../ExerciseCards/Beginner/Bchest.dart';
import '../ExerciseCards/Beginner/Blegs.dart';
import '../ExerciseCards/Intermediate/ILegs.dart';
import '../ExerciseCards/Intermediate/Iabs.dart';
import '../ExerciseCards/Intermediate/Iarm.dart';
import '../ExerciseCards/Intermediate/Ichest.dart';
import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../database/firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/levelhive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int? _level; // Default value
  Box? _profileBox;
  double _bmi = 0;
  String _bmiStatus = '';
  String _bmiMessage = '';
  HiveService _hiveService = HiveService();
  late String _userId;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _fetchProfileData();
  }

  Future<void> _initializeUserId() async {
    _userId = _getUserId();
    await _fetchLevelData();
    setState(() {
      _isDataLoaded = true; // Data is loaded and can be used
    });
  }

  String _getUserId() {
    Box userBox = Hive.box('userBox');
    String? userId = userBox.get('userId');
    if (userId == null) {
      userId = Uuid().v4();
      userBox.put('userId', userId);
    }
    return userId!;
  }

  Future<void> _fetchLevelData() async {
    _profileBox = await Hive.openBox('profileBox');
    _level = _profileBox?.get('level'); // Fetch the level
    if (_level == null) {
      _level = 1; // Default level for new users
      _profileBox?.put('level', _level); // Save the default level
    }
    setState(() {
      // Update the UI with the fetched level
    });

  }

// ...

/*
  Future<void> _initializeLevelData() async {
    await _hiveService.initializeUserLevel(_userId);

    // Fetch the initialized data
    Map<String, dynamic>? levelData = _hiveService.getUserLevelData(_userId);
    if (levelData != null) {
      setState(() {
        _level = levelData['level'] ?? 1; // Default to level 1 if not found
      });
    }
  }

/*
  Future<void> _initializeLevelData() async {
    await _hiveService.initializeUserLevel(_userId);

    // Fetch the initialized data
    Map<String, dynamic>? levelData = _hiveService.getUserLevelData(_userId);
    if (levelData != null) {
      setState(() {
        _level = levelData['level'] ?? 1; // Default to level 1 if not found
        _currentXp = levelData['currentXp'] ?? 0;
        _requiredXp = levelData['requiredXp'] ?? _calculateRequiredXp(_level + 1);
      });
    }
  }

 */
/*
  Future<Map<String, dynamic>> fetchQuote() async {
    final response = await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load quote');
    }
  }


 */
  Future<void> _fetchLevelData() async {
    _profileBox = await Hive.openBox('profileBox');
    setState(() {
      _level = _profileBox?.get('level', defaultValue: 0) ?? 0;
      //_currentXp = _profileBox?.get('xp', defaultValue: 0) ?? 0;
      //_requiredXp = _calculateRequiredXp(_level + 1); // XP needed for the next level
    });
  }
/*
  int _calculateRequiredXp(int level) {
    // Example calculation: Adjust as needed
    return 100 + (level * 100); // Example, adjust based on your needs
  }
  */


  Future<void> _updateLevelData(int level) async {
    await _hiveService.updateUserLevel(_userId, level);
    await _initializeLevelData(); // Re-fetch data after updating
  }

  /*
  void _addXp(int xpToAdd) async {
    _profileBox = await Hive.openBox('profileBox');
    int newXp = (_profileBox?.get('xp', defaultValue: 0) ?? 0) + xpToAdd;
    int newLevel = _level;

    // Check for level-up
    while (newXp >= _calculateRequiredXp(newLevel + 1)) {
      newXp -= _calculateRequiredXp(newLevel + 1);
      newLevel++;
    }

    await _updateLevelData(newLevel, newXp);

    setState(() {
      _level = newLevel;
      _currentXp = newXp;
      _requiredXp = _calculateRequiredXp(newLevel + 1) - newXp; // Update required XP
    });
  }

   */

 */

  Future<void> _fetchProfileData() async {
    _profileBox = await Hive.openBox('profileBox');
    double weight = double.parse(_profileBox!.get('weight'));
    double height = double.parse(_profileBox!.get('height'));
    String weightUnit = _profileBox!.get('weightUnit');
    String heightUnit = _profileBox!.get('heightUnit');
    String name = _profileBox!.get('name');

    // Convert units if necessary
    if (weightUnit == 'lbs') {
      weight = weight * 0.453592;
    }
    if (heightUnit == 'in') {
      height = height * 0.0254;
    } else if (heightUnit == 'cm') {
      height = height / 100;
    }

    setState(() {
      _bmi = weight / (height * height);
      //_bmi = 22.3;
      _updateBmiStatus();
    });
  }
  void _updateBmiStatus() {
    if (_bmi < 18.5) {
      _bmiStatus = 'Underweight';
      _bmiMessage = 'Don\'t Worry! You will Bulk up Soon!';
    } else if (_bmi >= 18.5 && _bmi < 24.9) {
      _bmiStatus = 'Normal';
      _bmiMessage = 'You\'re in a good shape!';
    } else {
      _bmiStatus = 'Overweight';
      _bmiMessage = 'Don\'t Worry! Keep Burning The Fuel!';
    }
  }


  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: MyAppBar(),
        ),
      ),
      bottomNavigationBar: MyCustomBottomNavBar(initialIndex: 0,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [TColor.primaryColor1, TColor.primaryColor2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Title on top of the container
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        'BMI (Body Mass Index)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          //backgroundColor: Colors.black45, // Optional background color for better visibility
                        ),
                      ),
                    ),
                    // Column with BMI content
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0), // Padding to ensure the text is not overlapped by the title
                      child: Column(
                        children: [
                          _bmi == 0
                              ? CircularProgressIndicator()
                              : SizedBox(
                            height: 200, // Specify a fixed height
                            child: BMIChart(bmi: _bmi),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _bmiStatus,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _bmiMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Level bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Level $_level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity, // Provide a bounded width
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            TColor.secondaryColor1,
                            TColor.secondaryColor2,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),

                      child: Stack(
                        children: [
                          Container(
                            width: 50 / 100 > 1 ? double.infinity : 50 / 100* MediaQuery.of(context).size.width, // Ensure the width is not greater than the parent width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    /*
                    Text(
                      '$_currentXp / $_requiredXp XP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),

                     */
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("Which exercise do you\n have in mind today?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              ),


              _buildWorkoutSection("Beginner"),
              _buildWorkoutSection("Intermediate"),
              _buildWorkoutSection("Advanced"),
              QuotesWidget(),
            ],

          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(String imagePath, Widget nextPage, {bool isLocked = false}) {
    return InkWell(
      onTap: isLocked
          ? () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Locked"),
            content: Text("You need to reach level ${isLocked ? ((_level ?? 0) < 10 ? 10 : 5) : 'any'} to unlock this workout."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
          : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextPage,
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            child: Image.asset(
              imagePath,
              //fit: BoxFit.cover, // Image fills the entire card
            ),
          ),
          if (isLocked)
            Positioned(
              top: 10,
              //right: 10,
              child: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildWorkoutSection(String category) {
    return Column(
      children: [
        _buildCategoryHeader(category),
        if (category == "Beginner")
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 4/3,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
              _buildWorkoutCard("lib/images/c_b.jpg",  ChestBegpage()),
              _buildWorkoutCard("lib/images/a_b.jpg",  ArmBegpage()),
              _buildWorkoutCard("lib/images/l_b.jpg",  LegsBegpage()),
              _buildWorkoutCard("lib/images/o_b.jpg",  ExercisePage1()),
            ],
          ),
        if (category == "Intermediate")
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 4/3,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
            _buildWorkoutCard("lib/images/c_i.jpg", ChestIntpage(), isLocked: (_level ?? 0) < 5),
            _buildWorkoutCard("lib/images/a_i.jpg",  ArmIntpage(), isLocked: (_level ?? 0) < 5),
            _buildWorkoutCard("lib/images/l_i.jpg",  LegsIntPage(), isLocked: (_level ?? 0) < 5),
            _buildWorkoutCard("lib/images/o_i.jpg",  AbsIntPage(), isLocked: (_level ?? 0) < 5),
            ],
          ),
        if (category == "Advanced")
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 4/3,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
            _buildWorkoutCard("lib/images/c_a.jpg",  ChestAdvPage(), isLocked: (_level ?? 0) < 10),
            _buildWorkoutCard("lib/images/a_a.jpg",  ArmAdvPage(), isLocked: (_level ?? 0) < 10),
            _buildWorkoutCard("lib/images/l_a.jpg",  LegsAdvPage(), isLocked: (_level ?? 0) < 10),
            _buildWorkoutCard("lib/images/o_a.jpg",  AbsAdvPage(), isLocked: (_level ?? 0) < 10),
            ],
          ),
      ],
    );
  }




}

class BMIChart extends StatelessWidget {
  final double bmi;

  BMIChart({required this.bmi});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PieChart(
      PieChartData(
        sections: _createSections(screenWidth, screenHeight),
        borderData: FlBorderData(show: false),
        sectionsSpace: screenWidth * 0.01, // Space between sections
        centerSpaceRadius: screenWidth * 0.1, // Center space radius
      ),
    );
  }

  List<PieChartSectionData> _createSections(double screenWidth, double screenHeight) {
    double remaining = 100 - bmi;
    return [
      PieChartSectionData(
        color: TColor.primaryColor1,
        value: remaining,
        title: '${remaining.toStringAsFixed(1)}%',
        radius: screenWidth * 0.12, // Radius for the first section
        titleStyle: TextStyle(
          fontSize: screenWidth * 0.04, // Font size for the title
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: TColor.secondaryColor1,
        value: bmi,
        title: '${bmi.toStringAsFixed(1)}%',
        radius: screenWidth * 0.14, // Radius for the second section
        titleStyle: TextStyle(
          fontSize: screenWidth * 0.04, // Font size for the title
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }

}