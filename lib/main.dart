import 'package:aoku/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AokuApp());
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
            title: 'Flutter Demo',
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Noto-Serif-Japanese',
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFF5F5F5),
                secondary: Color(0xFFF5F5F5),
                surface: Color(0xFFF5F5F5),
                background: Color(0xFFF5F5F5),
                error: Color(0xFFB00020),
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Noto-Serif-Japanese',
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF050A30),
                secondary: Color(0xFF050A30),
                surface: Color(0xFF050A30),
                background: Color(0xFF050A30),
                error: Color(0xFFB00020),
                onPrimary: Color(0xFFF5F5F5),
                onSecondary: Color(0xFFF5F5F5),
                onSurface: Color(0xFFF5F5F5),
                onBackground: Color(0xFFF5F5F5),
                onError: Color(0xFFF5F5F5),
                brightness: Brightness.dark,
              ),
            ),
            themeMode: ThemeMode.system,
            home: const HomePage(title: '聞く'),
          );
        }
      },
    );
  }
}
