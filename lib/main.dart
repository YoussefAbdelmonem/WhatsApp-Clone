import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/colors.dart';
import 'package:whats_app_clone/features/auth/screens/splash/splash_screen.dart';
import 'package:whats_app_clone/firebase_options.dart';
import 'package:whats_app_clone/screens/mobile_layout_screen.dart';
import 'package:whats_app_clone/utils/routes.dart';

import 'features/auth/controller/auth_controller.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,

          )
        ),
        scaffoldBackgroundColor: appBarColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
        data: (user) {
          if (user == null) {
            return const SplashScreen();
          }
          return const MobileLayoutScreen();
        }, error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
      }, loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

