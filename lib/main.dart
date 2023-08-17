import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/features/auth/login/screen/login_screen.dart';
import 'package:whats_app_clone/firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}

