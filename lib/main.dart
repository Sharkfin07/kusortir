// * Selamat datang di source code Kusortir!

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kusortir/presentation/screens/home/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kusortir/data/firebase/firebase_options.dart';
import 'package:kusortir/presentation/screens/authentication/sign_in_screen.dart';
import 'package:kusortir/presentation/screens/authentication/sign_up_screen.dart';
import 'package:kusortir/presentation/theme/theme.dart';
import 'package:kusortir/presentation/screens/item/add_item_form.dart';
import 'package:kusortir/presentation/screens/item/item_detail.dart';
import 'package:kusortir/presentation/controllers/auth_controller.dart';

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
      initialRoute: '/',
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const Homescreen()),
        GetPage(name: '/sign-in', page: () => const SignInScreen()),
        GetPage(name: '/sign-up', page: () => const SignUpScreen()),
        GetPage(name: '/add-item', page: () => const AddItemForm()),
        GetPage(name: '/item-detail', page: () => const ItemDetailScreen()),
      ],
    );
  }
}
