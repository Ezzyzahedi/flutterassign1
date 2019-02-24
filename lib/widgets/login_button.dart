import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final iconUrl;
  final callback;
  final socialMediaName;

  LoginButton({this.iconUrl, this.callback, this.socialMediaName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 2
      ),
      child: MaterialButton(
        color: Colors.orangeAccent,
        elevation: 2,
        onPressed: callback,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(width: 40.0, height: 40.0),
                child: Image.network(iconUrl),
              ),
              Container(
                width: 10,
              ),
              Container(
                child: Text(
                  "Continue with $socialMediaName",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
