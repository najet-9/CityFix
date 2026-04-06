import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cityfix/firebase_options.dart';
import 'package:cityfix/screens/wrapper.dart';
// 1. Importation du package de traduction
import 'package:easy_localization/easy_localization.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  // Initialisation des services Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialisation de Easy Localization
  await EasyLocalization.ensureInitialized();

  // Initialisation Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("a20c368d-e7a7-420b-8cdf-e6266b6e82ed");

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.notification.display(); // force showing notification
  });

  OneSignal.Notifications.requestPermission(true);

  // 3. Enveloppement de l'application avec EasyLocalization
  runApp(
    EasyLocalization(
      // Liste des langues supportées (Anglais, Français, Arabe)
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
      // Chemin vers tes fichiers JSON
      path: 'assets/translations',
      // Langue par défaut si la traduction est manquante
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityFix DZ',
      debugShowCheckedModeBanner: false,

      // 4. Configuration des délégués de localisation
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        textTheme: GoogleFonts.soraTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        primaryColor: const Color(0xFF2B58E4),
        useMaterial3: true,
      ),

      // Le Wrapper gère toujours ta session utilisateur
      home: const Wrapper(),
    );
  }
}
