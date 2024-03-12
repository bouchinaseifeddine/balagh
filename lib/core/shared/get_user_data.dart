import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balagh/model/user.dart';

Future<appUser?> getUserData(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      final userData = snapshot.data()!;
      List<String>? likedReports =
          List<String>.from(userData['likedReports'] ?? []);
      return appUser(
          id: userId,
          userName: userData['username'] ?? '',
          email: userData['email'] ?? '',
          imageUrl: userData['image_url'] ?? '',
          address: userData['address'] ?? '',
          role: userData['role'] ?? '',
          score: userData['score']);
    } else {
      print('User with ID $userId does not exist.');
      return null;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}
