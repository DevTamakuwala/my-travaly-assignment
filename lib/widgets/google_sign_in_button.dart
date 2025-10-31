import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Image.asset(
        'assets/google_logo.png',
        height: 24,
        width: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'G',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          );
        },
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black54,
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
