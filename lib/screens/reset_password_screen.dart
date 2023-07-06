import 'package:flutter/material.dart';
import 'package:talentrackats/services/network_helper.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();

  Future<void> _handleReset(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String code = _securityCodeController.text;

    String url = '/auth/reset-password';
    var data = {'email': email, 'securityCode': code, 'newPassword': password};

    NetworkHelper networkHelper = NetworkHelper();

    var response = await networkHelper.postData(url, data);

    if (response['statusCode'] == 200) {
      _showPopupDialog(context, 'Success', 'Password Reset Successfully', true);
    } else {
      _showPopupDialog(context, 'Failed', response['data']['message'], false);
      print('F');
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
                if (redirect) {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
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
        title: Text('Reset Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              obscureText: false,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _securityCodeController,
              decoration: InputDecoration(labelText: 'Security Code'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Change Password'),
              onPressed: () => _handleReset(context),
            ),
          ],
        ),
      ),
    );
  }
}
