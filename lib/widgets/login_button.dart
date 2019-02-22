import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final iconUrl;
  final callback;
  final socialMediaName;

  LoginButton({this.iconUrl, this.callback, this.socialMediaName});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: callback,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 0,
                color: Colors.transparent,
                child: Container(
                    constraints:
                        BoxConstraints.expand(width: 50.0, height: 50.0),
                    child: Image.network(iconUrl)),
                onPressed: () {},
              ),
              Text(
                "Continue with $socialMediaName",
                style: TextStyle(fontSize: 18.0),
              )
            ],
          )),
    );
  }
}
