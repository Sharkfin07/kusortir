import 'package:flutter/material.dart';
import 'package:kusortir/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kusortir/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => const Homescreen()},
    );
  }
}
