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
