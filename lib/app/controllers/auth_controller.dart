import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectmagang/app/routes/app_pages.dart';
import 'package:projectmagang/main.dart';


class AuthController extends GetxController {
  FirebaseAuth auth = main_auth;

  void resetPassword(String email) async {
    if (email.isNotEmpty && GetUtils.isEmail(email)) {
       try {
         await auth.sendPasswordResetEmail(email: email);
          Get.defaultDialog(
            title: "Berhasil", 
            middleText: "Kami telah mengirimkan reset password ke email $email.",
            onConfirm:  () {
              Get.back(); //close dialog
              Get.back(); // go to login
            },
            textConfirm:  "Ya, Aku Mengerti"
          );
       } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan", 
          middleText: "Tidak dapat mengirimkan reset password.",
        );
       }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan", 
        middleText: "Email tidak valid.",
      );
    }
  }

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void login(String email, String password) async {
    try {
      UserCredential myUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (myUser.user!.emailVerified) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.defaultDialog(
          title: "Verification Email",
          middleText: "Kamu perlu verifikasi email terlebih dahulu"
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Email atau password salah.');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'Email atau password salah.',
        );
      } else {
        print('Terjadi kesalahan saat login: $e');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'Tidak dapat login dengan akun ini.',
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat login: $e');
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: 'Tidak dapat login dengan akun ini.',
      );
    }
  }

  void signup(String email, String password) async {
    try {
      UserCredential myUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email, password: password);
      await myUser.user!.sendEmailVerification();
      Get.defaultDialog(
          title: "Verification Email",
          middleText: "Kami telah mengirimkan email verifikasi ke $email.",
          onConfirm: () {
            Get.back(); //close dialog
            Get.back(); // go to login
          },
          textConfirm: "Ya, Saya akan cek email.",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'The account already exists for that email.',
        );
      } else {
        print('Terjadi kesalahan saat signup: $e');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'Tidak dapat mendaftarkan akun ini.',
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat signup: $e');
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: 'Tidak dapat mendaftarkan akun ini.',
      );
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void verifikasi(String email, String password) {}
}
