import 'package:flutter/material.dart';
import 'package:my_travaly_assignment/screens/home_screen.dart';
// import 'package:my_travaly_assignment/services/auth_service.dart'; // Removed for frontend-only simulation
import 'package:my_travaly_assignment/widgets/google_sign_in_button.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;

  void _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false, // Remove all routes behind
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign In / Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/mt.png",
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 48),
              const Text(
                'Welcome!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                GoogleSignInButton(
                  onPressed: () {
                    _signInWithGoogle(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

