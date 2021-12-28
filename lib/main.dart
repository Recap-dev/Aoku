import 'package:aoku/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    const ProviderScope(
      child: AokuApp(),
    ),
  );
}

class AokuApp extends StatefulWidget {
  const AokuApp({Key? key}) : super(key: key);

  @override
  State<AokuApp> createState() => _AokuAppState();
}

class _AokuAppState extends State<AokuApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Something went wrong.'),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: Center(
                child: Image.asset('images/blue-blur-2.png'),
              ),
            ),
          );
        } else {
          // Equals to: if (snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            localizationsDelegates: [
              // Creates an instance of FirebaseUILocalizationDelegate with overriden labels
              //FlutterFireUILocalizations.withDefaultOverrides(
              //  const LabelOverrides(),
              //),

              // Delegates below take care of built-in flutter widgets
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,

              // This delegate is required to provide the labels that are not overriden by LabelOverrides
              FlutterFireUILocalizations.delegate,
            ],
            title: 'Aoku',
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Noto-Serif-Japanese',
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF58BAB3),
                secondary: Color(0xFFEBEBCF),
                surface: Color(0xFF7AACC9),
                background: Color(0xFF58BAB3),
                error: Color(0xFFB00020),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontFamily: 'Noto-Serif-Japanese',
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Noto-Serif-Japanese',
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF17302F),
                secondary: Color(0xFF192F40),
                surface: Color(0xFF2C3E47),
                background: Color(0xFF17302F),
                error: Color(0xFFB00020),
                onPrimary: Color(0xFFF5F5F5),
                onSecondary: Color(0xFFF5F5F5),
                onSurface: Color(0xFFF5F5F5),
                onBackground: Color(0xFFF5F5F5),
                onError: Color(0xFFF5F5F5),
                brightness: Brightness.dark,
              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontFamily: 'Noto-Serif-Japanese',
                ),
              ),
            ),
            themeMode: ThemeMode.system,
            home: const HomePage(),
          );
        }
      },
    );
  }
}
