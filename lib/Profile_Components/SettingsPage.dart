import 'package:flutter/material.dart';
import '../main.dart'; // Import the main.dart file to access the theme notifier

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dark Mode'),
            Switch(
              value: MyApp.themeNotifier.value == ThemeMode.dark,
              onChanged: (bool value) {
                MyApp.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ],
        ),
      ),
    );
  }
}
