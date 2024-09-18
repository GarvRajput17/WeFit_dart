import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'users'; // Collection to store user data

  Future<void> initializeUserLevel(String userId) async {
    DocumentReference userRef = _firestore.collection(collectionPath).doc(userId);

    await userRef.set({
      'level': 0,
      'xp': 0,
    });
  }

  Future<void> updateUserXp(String userId, int additionalXp) async {
    DocumentReference userRef = _firestore.collection(collectionPath).doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      int currentXp = userSnapshot['xp'];
      int currentLevel = userSnapshot['level'];

      int newXp = currentXp + additionalXp;
      int requiredXpForNextLevel = calculateXpForLevel(currentLevel + 1);

      if (newXp >= requiredXpForNextLevel) {
        int newLevel = currentLevel + 1;
        int excessXp = newXp - requiredXpForNextLevel;
        await userRef.update({
          'level': newLevel,
          'xp': excessXp,
        });
      } else {
        await userRef.update({
          'xp': newXp,
        });
      }
    }
  }

  int calculateXpForLevel(int level) {
    int xp = 100;
    for (int i = 1; i < level; i++) {
      xp = 100 + (xp * 3 ~/ 5);
    }
    return xp;
  }

  Future<Map<String, dynamic>?> getUserLevelData(String userId) async {
    DocumentReference userRef = _firestore.collection(collectionPath).doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}