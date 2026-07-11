import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/features/auth/presentation/pages/forgot_password.dart';
import 'package:al_hair_app/src/features/auth/presentation/pages/login_page.dart';
import 'package:al_hair_app/src/features/home/add_dermatologist_profile_page.dart';
import 'package:al_hair_app/src/features/home/admin_ai_accuracy_page.dart';
import 'package:al_hair_app/src/features/home/admin_approval_page.dart';
import 'package:al_hair_app/src/features/home/admin_faq_page.dart';
import 'package:al_hair_app/src/features/home/admin_manage_users_page.dart';
import 'package:al_hair_app/src/features/home/admin_notifications_page.dart';
import 'package:al_hair_app/src/features/home/admin_page.dart';
import 'package:al_hair_app/src/features/home/admin_role_access_page.dart';
import 'package:al_hair_app/src/features/home/admin_system_status_page.dart';
import 'package:al_hair_app/src/features/home/booking_page.dart';
import 'package:al_hair_app/src/features/home/device/connect_device_page.dart';
import 'package:al_hair_app/src/features/home/device/doctor_alert_page.dart';
import 'package:al_hair_app/src/features/home/device/doctor_availability_page.dart';
import 'package:al_hair_app/src/features/home/doctor_booking_page.dart';
import 'package:al_hair_app/src/features/home/doctor_calendar_page.dart';
import 'package:al_hair_app/src/features/home/doctor_chat_page.dart';
import 'package:al_hair_app/src/features/home/doctor_home_page.dart';
import 'package:al_hair_app/src/features/home/doctor_patient_list_page.dart';
import 'package:al_hair_app/src/features/home/export_data_page.dart';
import 'package:al_hair_app/src/features/home/language_page.dart';
import 'package:al_hair_app/src/features/home/patient_alert_page.dart';
import 'package:al_hair_app/src/features/home/profile_update_page.dart';
import 'package:al_hair_app/src/features/let_start_page.dart';
import 'package:al_hair_app/src/features/onboarding_page.dart';
import 'package:al_hair_app/src/features/services/connect_device.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'src/common/translations/l10n.dart';
import 'src/constants/navigation_path.dart';
import 'src/features/auth/presentation/pages/signup_page.dart';
import 'src/features/home/home_page.dart';
import 'src/features/home/system_health_page.dart';
import 'src/features/splash_screen.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔴 AUTO OFFLINE HANDLER
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final uid = storage.read('userid');
    if (uid == null) return;

    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        "isOnline": false,
        "lastActiveAt": Timestamp.now(),
      });
    }

    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        "isOnline": true,
        "lastActiveAt": Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (context) => S.of(context).appTitle,
      locale: Locale(
        storage.read('appLanguage') ?? "en",
      ),
      supportedLocales: const [
        Locale("ar"),
        Locale("en"),
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case NavigationPath.loginPage:
            return MaterialPageRoute(builder: (_) => const LoginPage());

          case NavigationPath.signupPage:
            return MaterialPageRoute(builder: (_) => const SignupPage());

          case NavigationPath.splashPage:
            return MaterialPageRoute(builder: (_) => const SplashPage());

          case NavigationPath.onboardingPage:
            return MaterialPageRoute(builder: (_) => const OnboardingPage());

          case NavigationPath.letStartPage:
            return MaterialPageRoute(builder: (_) => const LetStartPage());

          case NavigationPath.homePage:
            return MaterialPageRoute(builder: (_) => const HomePage());

          case NavigationPath.doctorHomePage:
            return MaterialPageRoute(builder: (_) => const DoctorHomePage());

          case NavigationPath.connectDevice:
            return MaterialPageRoute(builder: (_) => const ConnectDevice());

          case NavigationPath.forgotPassword:
            return MaterialPageRoute(builder: (_) => const ForgotPassword());

          case NavigationPath.adminPage:
            return MaterialPageRoute(builder: (_) => const AdminPage());

          case NavigationPath.addDermatologistProfilePage:
            return MaterialPageRoute(
              builder: (_) => const AddDermatologistProfilePage(),
            );

          case NavigationPath.adminApprovalPage:
            return MaterialPageRoute(builder: (_) => const AdminApprovalPage());

          case NavigationPath.adminManageUsersPage:
            return MaterialPageRoute(
              builder: (_) => const AdminManageUsersPage(),
            );

          case NavigationPath.adminRoleAccessPage:
            return MaterialPageRoute(
              builder: (_) => const AdminRoleAccessPage(),
            );

          case NavigationPath.adminSystemStatusPage:
            return MaterialPageRoute(
              builder: (_) => const AdminSystemStatusPage(),
            );

          case NavigationPath.adminNotificationsPage:
            return MaterialPageRoute(
              builder: (_) => const AdminNotificationsPage(),
            );

          case NavigationPath.adminFaqPage:
            return MaterialPageRoute(
              builder: (_) =>  AdminFaqPage(),
            );


          case NavigationPath.adminDoctorRatingsPage:
            return MaterialPageRoute(
              builder: (_) =>  AdminFaqPage(),
            );



          case NavigationPath.adminAiAccuracyPage:
            return MaterialPageRoute(
              builder: (_) =>  const AdminAiAccuracyPage(),
            );


          case NavigationPath.systemHealthPage:
            return MaterialPageRoute(
              builder: (_) =>  const SystemHealthPage(),
            );


          case NavigationPath.bookingPage:

            final args =
            routeSettings.arguments as Map<String, dynamic>;

            return MaterialPageRoute(
              builder: (_) => BookingPage(
                doctorId: args["doctorId"],
              ),
            );



          case NavigationPath.exportDataPage:
            return MaterialPageRoute(
              builder: (_) =>  const ExportDataPage(),
            );


          case NavigationPath.profileUpdatePage:
            return MaterialPageRoute(
              builder: (_) =>  const ProfileUpdatePage(),
            );


          case NavigationPath.languagePage:
            return MaterialPageRoute(
              builder: (_) =>  const LanguagePage(),
            );



          case NavigationPath.doctorBookingPage:
            return MaterialPageRoute(
              builder: (_) =>  const DoctorBookingPage(),
            );


          case NavigationPath.doctorCalendarPage:
            return MaterialPageRoute(
              builder: (_) =>  const DoctorCalendarPage(),
            );


          case NavigationPath.doctorPatientListPage:
            return MaterialPageRoute(
              builder: (_) =>  const DoctorPatientListPage(),
            );


          case NavigationPath.connectDevicePage:
            return MaterialPageRoute(
              builder: (_) =>  const ConnectDevicePage(),
            );


          case NavigationPath.doctorChatPage:

            final args =
            routeSettings.arguments
            as Map<String, dynamic>;

            return MaterialPageRoute(
              builder: (_) =>
                  DoctorChatPage(
                    chatId: args["chatId"],
                    patientName:
                    args["patientName"],
                  ),
            );


          case NavigationPath.doctorAvailabilityPage:
            return MaterialPageRoute(
              builder: (_) =>  const DoctorAvailabilityPage(),
            );


          case NavigationPath.doctorAlertPage:
            return MaterialPageRoute(
              builder: (_) =>  const DoctorAlertPage(),
            );


          case NavigationPath.patientAlertPage:
            return MaterialPageRoute(
              builder: (_) =>  const PatientAlertPage(),
            );


          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
      theme: ThemeData.light(),
      initialRoute: NavigationPath.splashPage,
    );
  }
}
