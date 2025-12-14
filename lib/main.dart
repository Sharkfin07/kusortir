// * Selamat datang di source code Kusortir!

import 'package:flutter/material.dart';
import 'package:kusortir/features/home/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kusortir/data/firebase/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kusortir/features/authentication/bloc/auth_bloc.dart';
import 'package:kusortir/features/authentication/screens/sign_in_screen.dart';
import 'package:kusortir/features/authentication/screens/sign_up_screen.dart';
import 'package:kusortir/theme/theme.dart';
import 'package:kusortir/features/item/screens/add_item_form.dart';
import 'package:kusortir/features/item/screens/item_detail.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(AuthCheck()),
      child: MaterialApp(
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
      ),
    );
  }
}
