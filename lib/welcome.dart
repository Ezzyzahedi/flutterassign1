import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Assign 1",
      home: _WelcomePage(),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome "
        ),
      ),
      body: Expanded(
        child: Text("Flutter Assign 1 complete"),
      ),
    );
  }
}