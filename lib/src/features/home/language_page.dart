import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  final storage = GetStorage();
  String selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    selectedLanguage =
        storage.read('appLanguage') ?? "en";
  }

  void changeLanguage(String code) {

    storage.write('appLanguage', code);

    getIt<NavigationService>()
        .navigatorKey
        .currentState!
        .pushNamedAndRemoveUntil(
      '/',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Select Language"),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            _languageCard(
              title: "English",
              code: "en",
              flag: "🇺🇸",
            ),

            const SizedBox(height: 20),

            _languageCard(
              title: "Arabic",
              code: "ar",
              flag: "🇸🇦",
            ),

          ],
        ),
      ),
    );
  }

  Widget _languageCard({
    required String title,
    required String code,
    required String flag,
  }) {

    final isSelected = selectedLanguage == code;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = code;
        });

        changeLanguage(code);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xff407CE2),
              Color(0xff6AA9FF),
            ],
          )
              : null,
          color: isSelected ? null : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [

            Text(
              flag,
              style: const TextStyle(fontSize: 26),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),

            if (isSelected)
              const Icon(Icons.check,
                  color: Colors.white),

          ],
        ),
      ),
    );
  }
}
