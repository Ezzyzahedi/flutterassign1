import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assign1/constants.dart';
import 'package:flutter_assign1/welcome.dart';
import 'package:flutter_assign1/widgets/login_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Login",
      home: _Login(),
      routes: <String, WidgetBuilder>{
        '/Welcome': (context) => Welcome(),
      },
      theme: ThemeData(
        accentColor: Colors.deepOrangeAccent,
        primaryColor: Colors.deepOrange
      ),
    );
  }
}

class _Login extends StatelessWidget {
  final FacebookLogin fbLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.currentUser()
          .then((currentUser)  {
        if (currentUser != null)
          Navigator.of(context)
              .pushReplacementNamed('/Welcome');
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Social Login"),
      ),
      body: body(context),
    );
  }

  Widget body(context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginButton(
              callback: () {
                _loginFacebook(context);
              },
              iconUrl: Constants.FB_ICON_URL,
              socialMediaName: "facebook",
            ),
            LoginButton(
              callback: () {
                _loginInstagram(context);
              },
              iconUrl: Constants.INSTA_ICON_URL,
              socialMediaName: "instagram (incomplete)",
            ),
          ],
        ),
      ),
    );
  }

  _loginFacebook(context) {
    fbLogin.logInWithReadPermissions(['email']).then((res) {
      switch (res.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: res.accessToken.token);
          FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((signedInUser) {
              print(signedInUser.displayName);
              _loginSuccess(context);
          }).catchError((err) => print(err));
          break;
        case FacebookLoginStatus.error:
          print('error');
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('cancelled');
          break;
      }
    }).catchError((err) => print(err));
  }

  _loginInstagram(context) {

  }

  _loginSuccess(context) {
    Navigator.of(context).pushReplacementNamed('/Welcome');
  }

}
