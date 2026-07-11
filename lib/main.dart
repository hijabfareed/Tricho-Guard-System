import 'package:al_hair_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'src/di/service_locator.dart';
import 'src/networks/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🟢 Initialize GetStorage (Crucial for saving login sessions)
  await GetStorage.init();

  print("STEP 1");

  await init();
  print("STEP 2");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("STEP 3");

  initRootLogger();
  print("STEP 4");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}