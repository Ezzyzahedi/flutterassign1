import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_assign1/widgets/login_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Login",
      home: _Login(),
      routes: <String, WidgetBuilder>{
        '/LandingPage': (BuildContext context) => MyApp(),
        '/Welcome': (BuildContext context) => Welcome(),
      },
    );
  }
}

class _Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<_Login> {
  FacebookLogin fbLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  Widget appBar() {
    return AppBar(
      title: Text("Social Login"),
      backgroundColor: Colors.deepOrange,
    );
  }

  Widget body() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginButton(
              callback: _facebookLogin,
              iconUrl: "https://cdn4.iconfinder.com/" +
                  "data/icons/social-media-icons-the-circle-set/48/" +
                  "facebook_circle-512.png",
              socialMediaName: "facebook",
            ),
            LoginButton(
              callback: _instaLogin,
              iconUrl: "https://cdn4.iconfinder.com/" +
                  "data/icons/social-messaging-ui-color-shapes-2-free/" +
                  "128/social-instagram-new-circle-512.png",
              socialMediaName: "instagram",
            ),
          ],
        ),
      ),
    );
  }

  _facebookLogin() {
    fbLogin.logInWithReadPermissions(['email']).then((res) {
      switch (res.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: res.accessToken.token);
          FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((signedInUser) {
            print(signedInUser.displayName);
            _loginSuccess();
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

  _instaLogin() {}

  _loginSuccess() {
    Navigator.of(context).pushReplacementNamed('/welcome');
  }
}
