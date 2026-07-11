import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SystemHealthPage extends StatefulWidget {
  const SystemHealthPage({super.key});

  @override
  State<SystemHealthPage> createState() => _SystemHealthPageState();
}

class _SystemHealthPageState extends State<SystemHealthPage> {
  bool firebaseOk = false;
  double aiAccuracy = 0;
  int chatsToday = 0;
  int onlineDoctors = 0;

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    await _checkFirebase();
    await _loadAiAccuracy();
    await _loadChats();
    await _loadDoctors();
  }

  /// 🔌 Firebase Ping
  Future<void> _checkFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('health_check')
          .doc('ping')
          .set({'time': FieldValue.serverTimestamp()});

      firebaseOk = true;
    } catch (_) {
      firebaseOk = false;
    }
    setState(() {});
  }

  /// 🤖 AI Accuracy
  Future<void> _loadAiAccuracy() async {
    final snap = await FirebaseFirestore.instance
        .collection('ai_predictions')
        .where('isCorrect', isEqualTo: true)
        .get();

    final total = await FirebaseFirestore.instance
        .collection('ai_predictions')
        .get();

    if (total.docs.isNotEmpty) {
      aiAccuracy = (snap.docs.length / total.docs.length) * 100;
    }

    setState(() {});
  }

  /// 💬 Chats Today
  Future<void> _loadChats() async {
    final today = DateTime.now();
    final snap = await FirebaseFirestore.instance
        .collection('Chat_Room')
        .where('createdAt',
        isGreaterThan:
        Timestamp.fromDate(DateTime(today.year, today.month, today.day)))
        .get();

    chatsToday = snap.docs.length;
    setState(() {});
  }

  /// 👨‍⚕️ Online Doctors
  Future<void> _loadDoctors() async {
    final snap = await FirebaseFirestore.instance
        .collection('dermatologists')
        .where('approvalStatus', isEqualTo: 'approved')
        .get();

    onlineDoctors = snap.docs.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("System Health")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _healthTile("Firebase Status", firebaseOk ? "Online" : "Down",
              firebaseOk ? Colors.green : Colors.red),
          _healthTile(
              "AI Accuracy", "${aiAccuracy.toStringAsFixed(1)}%", Colors.orange),
          _healthTile("Chats Today", chatsToday.toString(), Colors.blue),
          _healthTile(
              "Active Doctors", onlineDoctors.toString(), Colors.purple),
        ],
      ),
    );
  }

  Widget _healthTile(String title, String value, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
