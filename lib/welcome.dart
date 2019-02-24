import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WelcomePage();
  }
}

class _WelcomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<_WelcomePage> {
  var displayName = '';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser()
      .then((user) {
        setState(() {
          this.displayName = user.displayName;
        });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome ${this.displayName}"
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: MaterialButton(
          color: Colors.orangeAccent,
          elevation: 2,
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: Text("Sign out"),
        ),
      ),
    );
  }
}