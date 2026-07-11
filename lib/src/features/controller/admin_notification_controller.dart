import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationController {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required String target, // all | patient | doctor
  }) async {
    await _firestore.collection('notifications').add({
      'title': title,
      'message': message,
      'target': target,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
