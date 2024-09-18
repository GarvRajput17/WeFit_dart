# WeFit - Reshape Your Body, Reshape Your Lifestyle

## Problem Statement
Create a Workout-Based Mobile Application that helps users achieve their health and fitness goals in a structured and engaging way.

## Overview
**WeFit** is an all-in-one solution for your health and fitness requirements, standing out in the digital age today. This mobile application is designed to cater to various fitness needs, including personalized workout routines, tracking progress, and providing nutritional guidance. Whether you're a beginner or an advanced fitness enthusiast, WeFit has something to offer for everyone.

## Objectives
- **User Engagement:** Develop features that keep users engaged with their fitness routines.
- **Personalization:** Offer personalized workout plans from basic (beginner) to the advanced ones and recommendations based on user preferences.
- **Progress Tracking:** Provide users with tools to track their progress effectively.
- **Cross-Platform Compatibility:** App is designed to work on any Operating system of your choice.
- **Data Persistence:** Implement efficient data storage and retrieval using local databases.

## Implementation Details
- The application is built using Flutter for a consistent cross-platform experience.
- Local data storage is managed using Hive and Firebase, ensuring fast and reliable access to user data.
- User authentication and workout history are integrated with Firebase services.
- JSON is utilized for storing workout quotes and retreiving meals .
- Hive is used whenever required to store data locally ensuring that your workout goals doesnt get hindered by connectivity problems.
- YouTube Player integration allows users to follow workout videos directly within the app.


## Tech Stack

### Frontend
- **[Flutter](https://flutter.dev/):** The primary framework used for building the cross-platform mobile application.

### Backend
- **[Firebase](https://firebase.google.com/):** Used for authentication, real-time database, and cloud storage.
- **[Firebase Firestore](https://pub.dev/packages/cloud_firestore):** Cloud Firestore for scalable NoSQL database needs.
- **[Hive](https://pub.dev/packages/hive):** A lightweight and fast key-value database used for local storage.
- **[Firebase Authentication](https://pub.dev/packages/firebase_auth):** Handles user authentication via Firebase.

### Databases
- **Firebase Firestore:** For cloud-based data storage.
- **JSON:** Used for storing static workout data.
- **Hive:** For efficient local data storage.

## Getting Started
To get a local copy up and running, follow these steps:

1. **Configure Firebase:**
   - Generate a Firebase app and connect it to this project.
   - For authentication, enter your SHA-1 and SHA-256 keys into your Firebase Authentication console.
   - Update the `google-services.json` file for Android and `GoogleService-Info.plist` for iOS with your Firebase credentials.

2. **Clone the Repository:**
   ```sh
   git clone https://github.com/GarvRajput17/WeFit_app.git
3. Get Dependencies:
   ```sh
   flutter pub get
4. Configure Your Firebase API Keys
Generate a Firebase app.
Connect that app to this Git project.
For authentication, enter your SHA-1 and SHA-256 keys into your Firebase Authentication console.
Update the google-services.json in Android and GoogleService-Info.plist in iOS.

5. Set up your Emulator
Choose an emulator for testing (Pixel 8 Pro recommended).
Ensure your Kotlin version is set to 1.9.0.
Make sure you are using the latest version of Flutter.

6. Run The App

## Challenges Faced
1. Since the application has been developed during the learning phase itself, it took a lot of time understanding the basics.
2. State Management was very difficult considering Every widget in the flutter can be assigned a different state.
3. Updating the ios and android configuration files after every dependency update was difficult to maintain to ensure that every dependency works correctly.
4. CRUD operations in firebase and Hiver were more trickier than expected.
5. There are a lot of issues regarding UI management in different screen and it was challenging to check if every kind of screen works perfectly or not.

## Inspirations
1. UI has been taken from MitchKoko(YT) channel while learning.
2. Custom color and onboarding screens have been taken from CodeForAny(YT).
3. For vector arts, UI Mobile kit for workout app has been used and vecteezy for exercise models.
4. Workouts cards anf focus areas have been taken from HealthPlus homeworkout app
   
## Future Scope
1. Integration with Fitbits/Watches with the connection of apple health/ google fit to retrieve health data with these applications.
2. More Responsive design with taking account of different screens in mind.
3. Number of exercise challenges are limited, we will look to add more challenges and new workouts soon.
4. Moving to a more comprehensive Data storage like Mongo/Posgre.

## YT video Showing App Walkthrough
(https://www.youtube.com/watch?v=DUPYYNg9KF0)



