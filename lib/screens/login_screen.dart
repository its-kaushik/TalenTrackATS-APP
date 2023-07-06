import 'package:flutter/material.dart';
import 'package:talentrackats/services/network_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      String email = _usernameController.text;
      String password = _passwordController.text;

      String url = '/auth/login';
      var data = {'email': email, 'password': password};

      NetworkHelper networkHelper = NetworkHelper();

      var response = await networkHelper.postData(url, data);

      if (response['statusCode'] == 200) {
        //print(response);

        String accessToken = response['data']['data']['accessToken'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setBool('isLogged', true);

        _showPopupDialog(context, 'Success', 'Logged-In Successfully', true);
      } else {
        _showPopupDialog(context, 'Failed', response['data']['message'], false);
      }
    } catch (err) {
      print('1');
      print(err);
    }
  }

  void _showPopupDialog(
      BuildContext context, String title, String message, bool redirect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (redirect) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                child: Text('New User ? Register'),
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              GestureDetector(
                child: Text('Forgot Password ?'),
                onTap: () {
                  Navigator.pushNamed(context, '/send-reset-email');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
