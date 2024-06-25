import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Authentication/login.dart';
import 'package:todo/helper/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBTg8x4CmxwEyBNe_z8KFBvyb1arQahvV8",
          appId: "1:680754587079:android:ef299c48eff1cbc0f3a5e2",
          messagingSenderId: "680754587079",
          projectId: "todo-1b2f6",
          storageBucket: "todo-1b2f6.appspot.com"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => api()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginpage(),
      ),
    );
  }
}
