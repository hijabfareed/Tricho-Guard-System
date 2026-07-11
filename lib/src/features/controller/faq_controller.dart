import 'package:cloud_firestore/cloud_firestore.dart';

class FaqController {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFaqs() {
    return _firestore
        .collection('app_content')
        .doc('faqs')
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addFaq({
    required String question,
    required String answer,
  }) async {
    await _firestore
        .collection('app_content')
        .doc('faqs')
        .collection('items')
        .add({
      'question': question,
      'answer': answer,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateFaq({
    required String id,
    required String question,
    required String answer,
  }) async {
    await _firestore
        .collection('app_content')
        .doc('faqs')
        .collection('items')
        .doc(id)
        .update({
      'question': question,
      'answer': answer,
    });
  }

  Future<void> deleteFaq(String id) async {
    await _firestore
        .collection('app_content')
        .doc('faqs')
        .collection('items')
        .doc(id)
        .delete();
  }
}
