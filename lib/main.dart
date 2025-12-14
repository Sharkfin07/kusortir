// * Selamat datang di source code Kusortir!

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kusortir/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kusortir/firebase/firebase_options.dart';
import 'package:kusortir/screens/authentication/sign_in_screen.dart';
import 'package:kusortir/screens/authentication/sign_up_screen.dart';
import 'package:kusortir/theme/theme.dart';
import 'package:kusortir/screens/add_item_form.dart';
import 'package:kusortir/screens/item_detail.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/sign-in',
      routes: {
        '/': (context) => const Homescreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/add-item': (context) => const AddItemForm(),
        '/item-detail': (context) => const ItemDetailScreen(),
      },
    );
  }
}
