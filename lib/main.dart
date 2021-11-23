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
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            ),
          );
        } else {
          // Equals to: if (snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomePage(title: '聞く'),
          );
        }
      },
    );
  }
}
