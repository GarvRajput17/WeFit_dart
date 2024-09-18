import 'package:flutter/material.dart';
import '../pages/homepage1.dart';

class CustomPurpleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.purple[200], // Light purple background
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to another screen here (e.g., CartPage)
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        },
        style: ElevatedButton.styleFrom(
          // Set the button background color to transparent
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'GET STARTED NOW!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Arial',
          ),
        ),
      ),
    );
  }
}

