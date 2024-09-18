import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wefit/pages/OnBoarding.dart';
import 'package:wefit/pages/complete_profile.dart';
import '../components/customcolor.dart';

class ChangeProfilePage extends StatefulWidget {
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  String? _selectedWeightUnit = 'kg';
  String? _selectedHeightUnit = 'cm';
  String? _selectedGender;
  bool _vegOnlyMeal = true; // Default to 'Veg only meal'
  String? _selectedNonVegPreference;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _formIsValid = false;

  Box? _profileBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  void _validateForm() {
    setState(() {
      _formIsValid = _formKey.currentState!.validate();
    });
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    _profileBox = await Hive.openBox('profileBox');
    setState(() {});
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _profileBox!.put('dateOfBirth', _dateController.text);
      _profileBox!.put('weight', _weightController.text);
      _profileBox!.put('height', _heightController.text);
      _profileBox!.put('weightUnit', _selectedWeightUnit);
      _profileBox!.put('heightUnit', _selectedHeightUnit);
      _profileBox!.put('gender', _selectedGender);
      _profileBox!.put('vegOnlyMeal', _vegOnlyMeal);
      _profileBox!.put('nonVegPreference', _selectedNonVegPreference);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      _showWarningDialog();
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Please fill all the fields.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _profileBox == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  'Please complete your profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Enter the details below',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: customDecoration(),
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
                        _validateForm();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date of birth';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: customDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_selectedWeightUnit == 'kg') {
                              double kg = double.tryParse(value) ?? 0.0;
                              _weightController.text = kg.toString();
                            } else {
                              double lbs = double.tryParse(value) ?? 0.0;
                              _weightController.text = lbs.toString();
                            }
                            _validateForm();
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedWeightUnit,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedWeightUnit = newValue;
                            if (newValue == 'kg') {
                              double lbs = double.tryParse(_weightController.text) ?? 0.0;
                              _weightController.text = (lbs * 0.453592).toStringAsFixed(2);
                            } else {
                              double kg = double.tryParse(_weightController.text) ?? 0.0;
                              _weightController.text = (kg * 2.20462).toStringAsFixed(2);
                            }
                            _validateForm();
                          });
                        },
                        items: ['kg', 'lbs'].map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: customDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Height',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_selectedHeightUnit == 'cm') {
                              double cm = double.tryParse(value) ?? 0.0;
                              _heightController.text = cm.toString();
                            } else {
                              double inches = double.tryParse(value) ?? 0.0;
                              _heightController.text = inches.toString();
                            }
                            _validateForm();
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedHeightUnit,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedHeightUnit = newValue;
                            if (newValue == 'cm') {
                              double inches = double.tryParse(_heightController.text) ?? 0.0;
                              _heightController.text = (inches * 2.54).toStringAsFixed(2);
                            } else {
                              double cm = double.tryParse(_heightController.text) ?? 0.0;
                              _heightController.text = (cm * 0.393701).toStringAsFixed(2);
                            }
                            _validateForm();
                          });
                        },
                        items: ['cm', 'inches'].map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: customDecoration(),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    onChanged: (newValue) {


                      setState(() {
                        _selectedGender = newValue;
                        _validateForm();
                      });
                    },
                    items: ['Male', 'Female', 'Other'].map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: customDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: Text('Veg only meal'),
                        value: _vegOnlyMeal,
                        onChanged: (bool value) {
                          setState(() {
                            _vegOnlyMeal = value;
                            if (!_vegOnlyMeal) {
                              _selectedNonVegPreference = null;
                            }
                            _validateForm();
                          });
                        },
                      ),
                      if (!_vegOnlyMeal)
                        DropdownButtonFormField<String>(
                          value: _selectedNonVegPreference,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedNonVegPreference = newValue;
                              _validateForm();
                            });
                          },
                          items: [
                            'egg only',
                            'egg and milk-based products',
                            'chicken',
                            'seafood',
                            'Whole Non veg meal'
                          ].map((preference) {
                            return DropdownMenuItem<String>(
                              value: preference,
                              child: Text(preference),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Non Veg preferences',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (_vegOnlyMeal == false && (value == null || value.isEmpty)) {
                              return 'Please select your non-veg preference';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _formIsValid
                      ? () {
                    _saveProfile();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()), // Replace NextScreen with the actual screen you want to navigate to
                    );
                  }
                      : null,
                  child: Text(
                    'Update Details',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.secondaryColor1,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}