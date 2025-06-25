import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth_screen.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthScreen()),
        (route) => false,
  );
}