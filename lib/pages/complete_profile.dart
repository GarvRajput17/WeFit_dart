import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wefit/pages/OnBoarding.dart';
import '../components/customcolor.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedWeightUnit = 'kg';
  String? _selectedHeightUnit = 'cm';
  String? _selectedGender;

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
      print(_profileBox!.toMap()); // Print the box values to verify
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Profile'),
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
    Center(
    child: Image.asset('lib/images/Frame.png'),
    ),
    SizedBox(height: 16),
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
    TextFormField(
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
    _dateController.text = pickedDate.toLocal().toString();
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
    SizedBox(height: 16),
    Row(
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
      SizedBox(height: 16),
      Row(
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
      SizedBox(height: 16),
      DropdownButtonFormField<String>(
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
      SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _formIsValid ? _saveProfile : null,
            child: Text('Get started now', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.secondaryColor1,
            ),
          ),
        ],
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
