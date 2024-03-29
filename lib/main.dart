import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:green_heart/view/Login/LoginView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    FlutterStatusbarcolor.setStatusBarColor(Color(0xFF36DC55));
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _initialized = false;
  bool _error = false;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      // is in Release Mode ?
      print('Release');
    } else {
      print('Debug');
    }
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return CircularProgressIndicator();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginView();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
