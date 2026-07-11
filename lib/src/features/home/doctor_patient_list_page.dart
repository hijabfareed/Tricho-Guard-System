import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DoctorPatientListPage extends StatelessWidget {
  const DoctorPatientListPage({super.key});

  @override
  Widget build(BuildContext context) {

    final storage = GetStorage();
    final doctorId = storage.read('userid');

    return CommonScaffold(
      withAppBar: true,
      title: const Text("My Patients"),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('user2', isEqualTo: doctorId)
            .snapshots(),
        builder: (_, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No Patients Yet"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {

              final chatDoc = snapshot.data!.docs[index];
              final data =
              chatDoc.data() as Map<String, dynamic>;

              final patientId = data['user1'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(patientId)
                    .get(),
                builder: (_, patientSnap) {

                  if (!patientSnap.hasData) {
                    return const ListTile(
                        title: Text("Loading..."));
                  }

                  final patient =
                  patientSnap.data!.data()
                  as Map<String, dynamic>;

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                        patient['name'] ?? "Patient"),
                    subtitle: const Text(
                        "Tap to open chat"),
                    onTap: () {
                      getIt<NavigationService>()
                          .navigateTo(
                        NavigationPath.doctorChatPage,
                        data: {
                          "chatId": chatDoc.id,
                          "patientName":
                          patient['name'],
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
