import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

import 'package:projectmagang/app/controllers/auth_controller.dart';
// import 'package:projectmagang/app/modules/home/views/home_view.dart';
// import 'package:projectmagang/app/modules/login/views/login_view.dart';
import 'package:projectmagang/app/routes/app_pages.dart'; 

import 'package:firebase_core/firebase_core.dart';
import 'package:projectmagang/app/utils/loading.dart';


late final FirebaseApp app;
late final FirebaseAuth main_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyDqAFpgAcZ0tBV9qdZ8bDBFMlZPgrrV6WU", 
      appId:
      "1:74194472073:android:bfd86c24c64323c2594a58", 
      messagingSenderId: 
      "74194472073", 
      projectId: 
      "projectmagang-2a371", 
    ),
  );
  main_auth = FirebaseAuth.instanceFor(app: app);
  // final authC = Get.put(AuthController(), permanent: true);
  // await Firebase.initializeApp();
  FirebaseAuth.instance;
  final authC = Get.put(AuthController(), permanent: true);

  runApp(MyApp());
}
// final authC = Get.put(AuthController(), permanent: true);

class MyApp extends StatelessWidget {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);

          return GetMaterialApp(
            title: "Application",
            initialRoute:
             snapshot.data != null && snapshot.data!.emailVerified == true
             ? Routes.HOME 
             : Routes.LOGIN,
            getPages: AppPages.routes,
            // home: snapshot.data != null ? HomeView( ) : LoginView(),
          );
        }
        return LoadingView();
      },
    );
  }
}