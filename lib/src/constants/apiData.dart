import 'package:cloud_firestore/cloud_firestore.dart';

class ApiData {
  static CollectionReference user =
  FirebaseFirestore.instance.collection("Users");

  static CollectionReference chat =
  FirebaseFirestore.instance.collection("Chat");

  static CollectionReference booking =
  FirebaseFirestore.instance.collection("Booking");


}