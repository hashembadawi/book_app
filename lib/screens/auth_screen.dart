import 'package:flutter/material.dart';
import 'register_screen_content.dart';
import 'login_screen_content.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Book App', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white), // Apply to Register tab as well for consistency
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LoginScreenContent(),
            RegisterScreenContent(),
          ],
        ),
      ),
    );
  }
}