import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kusortir/data/firebase/auth_helper.dart' as auth_helper;

class AuthController extends GetxController {
  final Rxn<User> user = Rxn<User>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever<User?>(user, _handleAuthChange);
  }

  void _handleAuthChange(User? currentUser) {
    if (currentUser == null) {
      if (Get.currentRoute != '/sign-in') Get.offAllNamed('/sign-in');
    } else {
      if (Get.currentRoute != '/') Get.offAllNamed('/');
    }
  }

  Future<void> signIn(String email, String password) async {
    await _runAuthAction(
      () => auth_helper.signInWithEmail(email, password),
      successRoute: '/',
      fallbackMessage: 'Authentication failed',
    );
  }

  Future<void> signUp(String email, String password) async {
    await _runAuthAction(
      () => auth_helper.signUpWithEmail(email, password),
      successRoute: '/',
      fallbackMessage: 'Registration failed',
    );
  }

  Future<void> signOut() async {
    await auth_helper.signOut();
  }

  Future<void> _runAuthAction(
    Future<void> Function() action, {
    required String successRoute,
    required String fallbackMessage,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await action();
      Get.offAllNamed(successRoute);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Authentication', _mapError(e, fallbackMessage));
    } catch (e) {
      Get.snackbar('Authentication', fallbackMessage);
    } finally {
      isLoading.value = false;
    }
  }

  String _mapError(FirebaseAuthException e, String fallback) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'weak-password':
        return 'Password too weak.';
      case 'email-already-in-use':
        return 'Email already in use.';
      default:
        return fallback;
    }
  }
}
