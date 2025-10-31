import 'package:flutter/material.dart';
import 'package:my_travaly_assignment/screens/google_sign_in_screen.dart';
import 'package:my_travaly_assignment/screens/home_screen.dart';

void main() async {
  runApp(const MyApp(isSignedIn: false));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  const MyApp({super.key, required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTravaly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // If user is already signed in, go to HomeScreen, otherwise to GoogleSignInScreen
      home: isSignedIn ? const HomeScreen() : const GoogleSignInScreen(),
    );
  }
}
