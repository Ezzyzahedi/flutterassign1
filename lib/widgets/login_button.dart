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
                constraints:
                  BoxConstraints.expand(width: 50.0, height: 50.0),
                child: Image.network(iconUrl)
              ),
              Container(width: 10,),
              Text(
                "Continue with $socialMediaName",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
