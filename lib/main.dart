import 'package:flutter/material.dart';
import 'package:talentrackats/screens/applications_screen.dart';
import 'package:talentrackats/screens/home_screen.dart';
import 'package:talentrackats/screens/login_screen.dart';
import 'package:talentrackats/screens/profile_screen.dart';
import 'package:talentrackats/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentrackats/screens/reset_password_screen.dart';
import 'package:talentrackats/screens/send_email_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool checkLogged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePage(context);
  }

  void updatePage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = await prefs.getBool('isLogged') ?? false;

    setState(() {
      checkLogged = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalenTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: checkLogged ? '/home' : '/login',
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/applications': (context) => ApplicationsPage(),
        '/profile': (context) => ProfilePage(),
        '/send-reset-email': (context) => SendEmailPage(),
        '/reset-password': (context) => ResetPasswordPage()
      },
    );
  }
}
