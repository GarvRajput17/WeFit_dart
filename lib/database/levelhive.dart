import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final Box userBox = Hive.box('userBox'); // A separate box for storing user-related info

  // Method to get or create a unique ID for the user
  String getUserId() {
    String? userId = userBox.get('userId');
    if (userId == null) {
      userId = Uuid().v4(); // Generate a unique ID
      userBox.put('userId', userId); // Store the ID
    }
    return userId;
  }
}

class HiveService {
  final Box profileBox = Hive.box('profileBox'); // Open the profile box

  Future<void> initializeUserLevel(String userId) async {
    // Check if user data already exists
    if (!profileBox.containsKey(userId)) {
      await profileBox.put(userId, {
        'level': 1, // Start at level 1
      });
    }
  }

  Future<void> updateUserLevel(String userId, int newLevel) async {
    if (profileBox.containsKey(userId)) {
      await profileBox.put(userId, {
        'level': newLevel,
      });
    }
  }

  Map<String, dynamic>? getUserLevelData(String userId) {
    if (profileBox.containsKey(userId)) {
      return profileBox.get(userId) as Map<String, dynamic>?;
    }
    return null;
  }
}
