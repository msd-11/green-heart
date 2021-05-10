import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_heart/controllers/AuthController.dart';
import 'package:green_heart/view/HomePage.dart';
import 'package:green_heart/view/Register/RegisterView.dart';

import 'components/button.dart';
import 'components/fields.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  // Controller to being able to retrive the value inside TextField
  final emailAuth = TextEditingController();
  final passwordAuth = TextEditingController();

  // Auth controller to be able to login or register a user
  AuthenticationController c = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;

    // We check if a user is connected, if it is connected, we redirect him to the HomePage
    if (firebaseUser != null) {
      return HomePageView();
    } else {
      return Scaffold(
        backgroundColor: Color(0xFF36DC55),
        body: Center(
          child: Container(
            color: Color(0xFF36DC55),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 120.0, child: Icon(Icons.nat_rounded)),
                    SizedBox(height: 35.0),
                    emailField(emailAuth, style),
                    SizedBox(height: 25.0),
                    passwordField(passwordAuth, style),
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButton(
                        style, context, emailAuth.text, passwordAuth.text),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextButton(
                      child: Text("Register",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // If he clicks on Register button, he's redirected to the register View
                        Get.to(() => RegisterView());
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}